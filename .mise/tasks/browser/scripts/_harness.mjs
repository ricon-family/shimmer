// _harness.mjs — Playwright harness for shimmer browser tasks
//
// Modes:
//   login: Open headed browser, save storageState on navigation, wait for close
//   run:   Load storageState, run a script module, close browser

import { chromium } from 'playwright';
import { parseArgs } from 'node:util';
import { existsSync, chmodSync } from 'node:fs';
import { pathToFileURL } from 'node:url';

const { values, positionals } = parseArgs({
  options: {
    mode:        { type: 'string' },
    site:        { type: 'string' },
    'auth-file': { type: 'string' },
    script:      { type: 'string' },
    headed:      { type: 'string', default: 'false' },
  },
  allowPositionals: true,
  strict: false,
});

const mode = values.mode;
const site = values.site;
const authFile = values['auth-file'];
const scriptPath = values.script;
const headed = values.headed === 'true';

if (mode === 'login') {
  const browser = await chromium.launch({ headless: false });
  const context = await browser.newContext();
  const page = await context.newPage();

  await page.goto(`https://${site}/login`);

  // Save auth state once when navigating away from the login page
  // (i.e., login succeeded). We can't save after browser disconnect
  // because the context is already gone by then.
  let saved = false;
  page.on('framenavigated', async (frame) => {
    if (frame !== page.mainFrame()) return;
    const url = frame.url();
    if (url.includes('/login') || url === 'about:blank') return;
    if (saved) return;
    saved = true;
    try {
      await context.storageState({ path: authFile });
      chmodSync(authFile, 0o600);
      console.log('Auth captured. You can close the browser now.');
    } catch {
      // Context may be closing
    }
  });

  // Wait for user to close the page/tab, then shut down the browser process.
  // "Chrome for Testing" doesn't exit when the last window closes, so we
  // listen for the page close event instead of browser disconnect.
  await new Promise(resolve => page.on('close', resolve));
  await browser.close();

} else if (mode === 'run') {
  if (!existsSync(authFile)) {
    console.error(`Auth file not found: ${authFile}`);
    console.error(`Run: shimmer browser:login ${site}`);
    process.exit(1);
  }

  const browser = await chromium.launch({ headless: !headed });
  const context = await browser.newContext({ storageState: authFile });
  const page = await context.newPage();

  const scriptModule = await import(pathToFileURL(scriptPath).href);

  try {
    await scriptModule.default({ page, context, browser, args: positionals });
  } catch (err) {
    console.error(`Script failed: ${err.message}`);
    await browser.close();
    process.exit(1);
  }

  // Save updated auth (cookies may have been refreshed)
  await context.storageState({ path: authFile });
  chmodSync(authFile, 0o600);
  await browser.close();
} else {
  console.error(`Unknown mode: ${mode}`);
  process.exit(1);
}
