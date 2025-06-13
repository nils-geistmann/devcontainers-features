#!/usr/bin/env bash

source dev-container-features-test-lib
source test_functions.sh

check "sudo does not require a password" assert_sudo_requires_no_password "remote"

reportResults
