#!/bin/bash

# -n : nodaemon
# -u=user 
exec supervisord -u=www-data -n
