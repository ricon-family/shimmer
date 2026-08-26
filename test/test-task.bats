#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

write_passing_test() {
  local path="$1" name="$2"
  mkdir -p "$(dirname "$path")"
  local test_keyword='@test'
  printf '%s\n' \
    '#!/usr/bin/env bats' \
    "$test_keyword \"$name\" {" \
    '  true' \
    '}' > "$path"
}

run_test_task() {
  (cd "$REPO_DIR" && mise run -q test "$@")
}

@test "options-only calls use the configured Shimmer test directory" {
  run run_test_task --jobs 1 --filter '^status shows telemetry is off when TELEMETRY_FILE unset$'

  [ "$status" -eq 0 ]
  [[ "$output" == *'1..1'* ]]
  [[ "$output" == *'ok 1 status shows telemetry is off when TELEMETRY_FILE unset'* ]]
}

@test "an explicit test target takes precedence over the configured default" {
  local target="$BATS_TEST_TMPDIR/explicit.bats"
  write_passing_test "$target" 'explicit target only'

  run run_test_task --jobs 1 "$target"

  [ "$status" -eq 0 ]
  [[ "$output" == *'1..1'* ]]
  [[ "$output" == *'ok 1 explicit target only'* ]]
}

@test "relative test targets resolve from the repository root" {
  run run_test_task --jobs 1 test/telemetry/status.bats \
    --filter '^status shows telemetry is off when TELEMETRY_FILE unset$'

  [ "$status" -eq 0 ]
  [[ "$output" == *'1..1'* ]]
  [[ "$output" == *'ok 1 status shows telemetry is off when TELEMETRY_FILE unset'* ]]
}

@test "whitespace-bearing explicit test targets remain one argument" {
  local target="$BATS_TEST_TMPDIR/explicit target/passing test.bats"
  write_passing_test "$target" 'whitespace target'

  run run_test_task --jobs 2 "$target"

  [ "$status" -eq 0 ]
  [[ "$output" == *'1..1'* ]]
  [[ "$output" == *'ok 1 whitespace target'* ]]
}

@test "public Shimmer test path runs separate BATS files concurrently" {
  local probe_dir="$BATS_TEST_TMPDIR/across-file-probe"
  export PROBE_DIR="$BATS_TEST_TMPDIR/across-file-barrier"
  mkdir -p "$probe_dir" "$PROBE_DIR"
  local test_keyword='@test'

  for side in one two; do
    other=one
    [ "$side" = one ] && other=two
    cat > "$probe_dir/$side.bats" <<BATS
#!/usr/bin/env bats
$test_keyword "$side worker observes $other worker" {
  touch "\$PROBE_DIR/$side"
  for _ in {1..50}; do
    [ ! -e "\$PROBE_DIR/$other" ] || return 0
    sleep 0.05
  done
  false
}
BATS
  done

  run run_test_task "$probe_dir"

  [ "$status" -eq 0 ]
}

@test "public Shimmer test path runs tests within one BATS file concurrently" {
  local target="$BATS_TEST_TMPDIR/within-file.bats"
  export PROBE_DIR="$BATS_TEST_TMPDIR/within-file-barrier"
  mkdir -p "$PROBE_DIR"
  local test_keyword='@test'

  cat > "$target" <<BATS
#!/usr/bin/env bats
$test_keyword "first worker observes second worker" {
  touch "\$PROBE_DIR/one"
  for _ in {1..50}; do
    [ ! -e "\$PROBE_DIR/two" ] || return 0
    sleep 0.05
  done
  false
}
$test_keyword "second worker observes first worker" {
  touch "\$PROBE_DIR/two"
  for _ in {1..50}; do
    [ ! -e "\$PROBE_DIR/one" ] || return 0
    sleep 0.05
  done
  false
}
BATS

  run run_test_task "$target"

  [ "$status" -eq 0 ]
}
