#!/bin/bash

# -n : nodaemon (important to keep container up)
# -c : config file location
exec supervisord -c=/etc/supervisor/supervisord.conf -n
