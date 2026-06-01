#!/bin/bash
. /etc/ddev-env 2>/dev/null
cd /var/www/html
if [ -n "$SSH_ORIGINAL_COMMAND" ]; then
    eval "$SSH_ORIGINAL_COMMAND"
else
    exec bash -l
fi
