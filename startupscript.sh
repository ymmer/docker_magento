#!/bin/bash

# -n : nodaemon
# -u=user 
exec supervisord -c=/etc/supervisor/supervisor.conf -n
