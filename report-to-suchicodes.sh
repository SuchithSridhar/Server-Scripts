#!/bin/bash

# Author: Suchith Sridhar
# Website: https://suchicodes.com
# Date: 2024, Jan 16

# Required variables in ~/.env file:
# SERVER_NAME
# SUCHICODES_SERVER_PASSWORD
#
# Depends on:
# open-from-suchicodes.sh
# close-from-suchicodes.sh

# Source environment variables
if [ -f "$HOME/.env" ]; then
    source $HOME/.env
fi

if [[ "$SUCHICODES_SERVER_PASSWORD" == "" ]]; then
    echo "Server suchicodes password not set."
    exit 1
else 
    password="$SUCHICODES_SERVER_PASSWORD"
fi

if [[ "$SERVER_NAME" == "" ]]; then
    echo "Server name not set."
    exit 1
else 
    server="$SERVER_NAME"
fi

# Additional tags may be provided when the script is called.
# Example: server-restart
if [[ "$1" == "" ]]; then
    tags="$server,server-checkin"
else
    tags="$server,server-checkin,$1"
fi

URL="https://suchicodes.com/admin/log-external-message"
script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

msg=`curl -X POST -F "tags=$tags" -F "pass=$password" -F "user=$server" -F "message=$server server checkin." $URL`
op=`echo $msg | sed 's/<br>/\n/g' | grep 'operation:'`

if [[ "$op" == "" ]]; then
    # No operation to be performed
    echo "no operation to be performed"
else
    op=`echo $op | cut -d' ' -f2`
    case "$op" in
        "restart")
            # Ensure sudoers file contains permissions for reboot
            # sudo visudo
            # username ALL=(ALL) NOPASSWD: /sbin/reboot
            sudo reboot
        ;;
        "ssh-start") 
            bash "${script_dir}/open-from-suchicodes.sh"
        ;;
        "ssh-stop") 
            bash "${script_dir}/close-from-suchicodes.sh"
        ;;
        "high-poll") 
            bash "${script_dir}/high-poll-report.sh"
        ;;
        *)
        ;;
    esac
fi
