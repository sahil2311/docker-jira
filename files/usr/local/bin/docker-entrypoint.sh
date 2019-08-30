#!/bin/bash

set -o xtrace

# Prepend executable if command starts with an option
if [ "${1:0:1}" = '-' ]; then
    set -- /opt/atlassian/jira/bin/start-jira.sh "$@"
fi

# Allow the container to be stated with `--user`
if [ "$1" = '/opt/atlassian/jira/bin/start-jira.sh' ] && [ "$(id -u)" = '0' ]; then
    mkdir -p $JIRA_HOME
    chown -Rf $JIRA_OWNER:$JIRA_GROUP $JIRA_HOME
    chmod 0755 $JIRA_HOME
    exec gosu $JIRA_OWNER "$BASH_SOURCE" "$@"
fi

exec "$@"
