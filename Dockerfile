# (c) Wong Hoi Sing Edison <hswong3i@pantarei-design.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:18.04

ENV JIRA_OWNER                   "jira"
ENV JIRA_GROUP                   "jira"
ENV JIRA_HOME                    "/var/atlassian/application-data/jira"
ENV JIRA_CATALINA                "/opt/atlassian/jira"
ENV JIRA_DOWNLOAD_URL            "https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-core-8.1.0.tar.gz"
ENV JIRA_DOWNLOAD_DEST           "/tmp/atlassian-jira-core-8.1.0.tar.gz"
ENV JIRA_DOWNLOAD_CHECKSUM       "sha1:5d3c241dfa5da2a8eecb8cc875d5cbd34fa62217"
ENV JAVA_HOME                    "/usr/lib/jvm/java-8-openjdk-amd64"
ENV JVM_MINIMUM_MEMORY           "384m"
ENV JVM_MAXIMUM_MEMORY           "768m"
ENV CATALINA_CONNECTOR_PROXYNAME ""
ENV CATALINA_CONNECTOR_PROXYPORT ""
ENV CATALINA_CONNECTOR_SCHEME    "http"
ENV CATALINA_CONNECTOR_SECURE    "false"
ENV CATALINA_CONTEXT_PATH        ""
ENV JVM_SUPPORT_RECOMMENDED_ARGS "-Datlassian.plugins.enable.wait=300 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1"
ENV TZ                           "UTC"
ENV SESSION_TIMEOUT              "300"

VOLUME  $JIRA_HOME
WORKDIR $JIRA_HOME

EXPOSE 8005
EXPOSE 8080

ENTRYPOINT [ "dumb-init", "--" ]
CMD        [ "docker-entrypoint.sh" ]

# Explicitly set system user UID/GID
RUN set -ex \
    && groupadd -r $JIRA_OWNER \
    && useradd -r -g $JIRA_GROUP -d $JIRA_HOME -M -s /usr/sbin/nologin $JIRA_OWNER

# Prepare APT dependencies
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install ca-certificates curl gcc libffi-dev libssl-dev make python python-dev sudo \
    && rm -rf /var/lib/apt/lists/*

# Install PIP
RUN set -ex \
    && curl -skL https://bootstrap.pypa.io/get-pip.py | python

# Install PIP dependencies
RUN set -ex \
    && pip install --upgrade ansible ansible-lint molecule yamllint \
    && rm -rf /root/.cache/*

# Copy files
COPY files /

# Bootstrap with Ansible
RUN set -ex \
    && cd /etc/ansible/roles/localhost \
    && molecule test \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cache/* \
    && rm -rf /tmp/*
