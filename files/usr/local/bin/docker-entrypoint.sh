#!/bin/bash

set -o xtrace

# Prepend executable if command starts with an option
if [ "${1:0:1}" = '-' ]; then
    set -- /opt/atlassian/jira/bin/start-jira.sh "$@"
fi

# Ensure required folders exist with correct owner:group
mkdir -p $JIRA_HOME
chown -Rf $JIRA_OWNER:$JIRA_GROUP $JIRA_HOME
chmod 0755 $JIRA_HOME

exec "$@"
