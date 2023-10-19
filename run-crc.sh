#!/bin/bash

CRC_LOG_FILE="~/crc-start.log"

#is crc running? (crc status always returns 0)
if ! ~/bin/crc ip ; then
    #run crc start directly (which will just say "done already" not error if running)
    #crc start -p ~/pull-secret > $CRC_LOG_FILE 2>&1

    #run crc start (which will just say "done already" not error if running)
    echo "running crc start in the background"
    tmux new-session -d -s 'crc-start' \
        "~/bin/crc start -p ~/pull-secret > $CRC_LOG_FILE 2>&1"

    echo "crc start is running in a tmux session in the Vagrant VM. " \
        "You can check its status with 'vagrant ssh -c \"tail -f $CRC_LOG_FILE\"'"
else
    echo "crc is already running on this instance."
fi

#start script to setup remote access to crc
echo "Running remote-config setup in background"
tmux new-session -d -s 'config-remote' \
        "~/configure-remote.sh > $REMOTE_LOG_FILE 2>&1"
echo "Remote config shell script is running in a tmux session in the Vagrant VM." \
        "You can check its status with 'vagrant ssh -c \"tail -f $REMOTE_LOG_FILE\"'"
echo "When everything is complete, please see $REMOTE_LOG_FILE for instructions on configuring your host's DNS"