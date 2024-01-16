#!/bin/bash

# Author: Suchith Sridhar
# Website: https://suchicodes.com
# Date: 2024, Jan 16

# Required variables in ~/.env file:
# REMOTE_SUCHICODES_PORT

# Source environment variables
if [ -f "~/.env" ]; then
    source ~/.env
fi

remote_ip=suchicodes.com
remote_user=suchi
local_port=22

if [[ "$REMOTE_SUCHICODES_PORT" == "" ]]; then
    remote_port=2334
else 
    remote_port="$REMOTE_SUCHICODES_PORT"
fi

ssh_connection_check=$(ps aux | grep "$remote_user@$remote_ip" |
                       grep "$remote_port:localhost:$local_port" |
                       grep -v grep | awk '{print $2}')

if [ ! -z "$ssh_connection_check" ]; then
    echo "Killing the following PIDs: $ssh_connection_check"
    echo $ssh_connection_check | xargs kill
fi
