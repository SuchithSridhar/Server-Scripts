#!/bin/bash

# Author: Suchith Sridhar
# Website: https://suchicodes.com
# Date: 2022, Dec 20

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
    echo "Remote port not set."
    exit 1
else 
    remote_port="$REMOTE_SUCHICODES_PORT"
fi

ssh_connection_check=$(ps aux | grep $remote_user@$remote_ip |
                       grep "$remote_port:localhost:$local_port" |
                       grep -v grep)

if [[ -z $ssh_connection_check ]]; then
    echo "Starting new reverse ssh connection."
    ssh -R $remote_port:localhost:$local_port -N $remote_user@$remote_ip \
        -o TCPKeepAlive=yes -o ServerAliveCountMax=20 -o ServerAliveInterval=15
else
    echo "SSH connection already exists."
fi
