#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my_app >&2
  dokku "$PLUGIN_COMMAND_PREFIX:create" l >&2
}

teardown() {
  reset_system_data
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:unlink"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) error when the app argument is missing" {
  run dokku "$PLUGIN_COMMAND_PREFIX:unlink" l
  assert_contains "${lines[*]}" "Please specify an app to run the command on"
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) error when the app does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:unlink" l not_existing_app
  assert_contains "${lines[*]}" "App not_existing_app does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) error when the service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:unlink" not_existing_service my_app
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) error when service not linked to app" {
  run dokku "$PLUGIN_COMMAND_PREFIX:unlink" l my_app
  assert_contains "${lines[*]}" "Not linked to app my_app"
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) removes link from docker-options" {
  dokku "$PLUGIN_COMMAND_PREFIX:link" l my_app >&2
  dokku "$PLUGIN_COMMAND_PREFIX:unlink" l my_app

  check_value=""
  report_action="docker-options"
  check_value="Docker options build: Docker options deploy: --restart=on-failure:10 Docker options run:"
  report_action="docker-options:report"

  options=$(dokku --quiet $report_action my_app | xargs)
  assert_equal "$options" "$check_value"
}

@test "($PLUGIN_COMMAND_PREFIX:unlink) unsets config url from app" {
  dokku "$PLUGIN_COMMAND_PREFIX:link" l my_app >&2
  dokku "$PLUGIN_COMMAND_PREFIX:unlink" l my_app
  config=$(dokku config:get my_app ELASTICSEARCH_URL || true)
  assert_equal "$config" ""
}
