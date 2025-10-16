#!/bin/bash

set -e

source test_functions.sh

# Test if the user is added to the specified additional groups
check "user exists" bash -c "id remote"
check "user in audio group" bash -c "id -nG remote | grep -q audio"
check "user in video group" bash -c "id -nG remote | grep -q video"
check "user in plugdev group" bash -c "id -nG remote | grep -q plugdev"

# Verify groups exist first
check "audio group exists" bash -c "getent group audio"
check "video group exists" bash -c "getent group video"
check "plugdev group exists" bash -c "getent group plugdev"

reportResults