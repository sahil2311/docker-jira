#!/bin/bash

set -o xtrace

# Ensure required folders exist with correct owner:group
mkdir -p $JIRA_HOME
chmod 0755 $JIRA_HOME
chown -Rf $JIRA_OWNER:$JIRA_GROUP $JIRA_HOME

# Running JIRA in foreground
exec /etc/init.d/jira start -fg
