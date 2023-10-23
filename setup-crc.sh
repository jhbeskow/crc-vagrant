#!/bin/bash

CRC_LOG_FILE="~/crc-start.log"
REMOTE_LOG_FILE="~/remote-config.log"

#is crc running? (crc status always returns 0)
if ! ~/bin/crc ip ; then

    sudo dnf -y install curl tar xz tmux

    #go get crc if it isn't downloaded
    echo "downloading crc"
    test -f "crc-linux-amd64.tar.xz" || curl -O -L -sS  \
        "https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz"

    #extract crc
    echo "extracting crc"
    tar -xf crc-linux-amd64.tar.xz

    #get crc in to a runnable place
    echo "setting crc as executable"
    mkdir ~/bin || :
    ln -sf ~/crc-linux-*-amd64/crc ~/bin/crc
    grep 'PATH=$PATH:$HOME/bin' ~/.bashrc ||  \
        echo "export PATH=$PATH:$HOME/bin" >> ~/.bashrc

    #run crc setup if it hasn't been done
    echo "running crc setup"
    until ~/bin/crc setup
    do
        echo "Retrying..."
    done
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
