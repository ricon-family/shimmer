#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
  load helpers
  setup_agent quick

  mkdir -p "$TEST_AGENT_HOME/.mise/tasks/agent"
  cat > "$TEST_AGENT_HOME/.mise/tasks/agent/list" <<'TASK'
#!/usr/bin/env bash
printf '%s\n' quick
TASK
  chmod +x "$TEST_AGENT_HOME/.mise/tasks/agent/list"
  printf '[tools]\n' > "$TEST_AGENT_HOME/mise.toml"

  export MISE_TRUSTED_CONFIG_PATHS="$TEST_AGENT_HOME${MISE_TRUSTED_CONFIG_PATHS:+:$MISE_TRUSTED_CONFIG_PATHS}"
}

run_agent_find() {
  run env \
    AGENT_HOME="$TEST_AGENT_HOME" \
    SHIMMER_CALLER_PWD="$TEST_AGENT_HOME" \
    usage_agent=quick \
    usage_repo= \
    "$SHIMMER_DIR/.mise/tasks/agent/find"
}

@test "agent:find returns a GitHub slug without embedded credentials" {
  git -C "$TEST_AGENT_HOME" remote add origin 'https://token:secret@github.com/owner/repo.git'

  run_agent_find

  [ "$status" -eq 0 ]
  [ "$output" = "owner/repo" ]
  [[ "$output" != *token* ]]
  [[ "$output" != *secret* ]]
}

@test "agent:find rejects another host without exposing its remote" {
  git -C "$TEST_AGENT_HOME" remote add origin 'https://token:secret@example.com/owner/repo.git'

  run_agent_find

  [ "$status" -eq 1 ]
  [[ "$output" == *"could not determine a GitHub repo"* ]]
  [[ "$output" != *token* ]]
  [[ "$output" != *secret* ]]
  [[ "$output" != *example.com* ]]
}
