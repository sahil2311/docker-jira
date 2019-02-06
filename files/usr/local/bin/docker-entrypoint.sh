#!/bin/bash

set -o xtrace

# Running JIRA in foreground
exec /etc/init.d/jira start -fg
