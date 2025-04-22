#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"$SCRIPT_DIR/updater.sh"
"$SCRIPT_DIR/prefsCleaner.sh"
"$SCRIPT_DIR/update-pywalfox.sh"
