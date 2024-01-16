#!/bin/bash

# Author: Suchith Sridhar
# Website: https://suchicodes.com
# Date: 2024, Jan 16

# Required variables in ~/.env file:
# REMOTE_SUCHICODES_PORT

# Source environment variables
if [ -f "$HOME/.env" ]; then
    source $HOME/.env
fi

remote_ip=suchicodes.com
remote_user=suchi
local_port=22

if [[ "$REMOTE_SUCHICODES_PORT" == "" ]]; then
    echo "Remote port not set."
    exit 1
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
