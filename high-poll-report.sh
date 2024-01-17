#!/bin/bash

# Author: Suchith Sridhar
# Website: https://suchicodes.com
# Date: 2024, Jan 16

# Depends on:
# report-to-suchicodes.sh

# Source environment variables
if [ -f "$HOME/.env" ]; then
    source $HOME/.env
fi

# Script name
script_name="high-poll-report.sh"
script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# Kill any running instances of this script, except the current one
pgrep -f $script_name | grep -v $$ | xargs -r kill

# Run for 5 minutes (300 seconds)
# Poll every 5 seconds
end=$((SECONDS+300))
while [ $SECONDS -lt $end ]; do
    bash "${script_dir}/report-to-suchicodes.sh" &
    sleep 5
done
