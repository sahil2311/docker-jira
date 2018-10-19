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

FROM ubuntu:16.04

ENV JIRA_OWNER                   "daemon"
ENV JIRA_GROUP                   "daemon"
ENV JIRA_HOME                    "/var/atlassian/application-data/jira"
ENV JIRA_CATALINA                "/opt/atlassian/jira"
ENV JIRA_DOWNLOAD_URL            "https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-core-7.12.3.tar.gz"
ENV JAVA_HOME                    "/usr/java/default"
ENV JVM_MINIMUM_MEMORY           "384m"
ENV JVM_MAXIMUM_MEMORY           "768m"
ENV CATALINA_CONNECTOR_PROXYNAME ""
ENV CATALINA_CONNECTOR_PROXYPORT ""
ENV CATALINA_CONNECTOR_SCHEME    "http"
ENV CATALINA_CONNECTOR_SECURE    "false"
ENV CATALINA_CONTEXT_PATH        ""
ENV JVM_SUPPORT_RECOMMENDED_ARGS "-Datlassian.plugins.enable.wait=300"
ENV TZ                           "UTC"
ENV SESSION_TIMEOUT              "300"

VOLUME  $JIRA_HOME
WORKDIR $JIRA_HOME

EXPOSE 8005
EXPOSE 8080

ENTRYPOINT [ "dumb-init", "--" ]
CMD        [ "/etc/init.d/jira", "start", "-fg" ]

# Prepare APT depedencies
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y alien apt-transport-https apt-utils aptitude bzip2 ca-certificates curl debian-archive-keyring debian-keyring git htop patch psmisc python-apt rsync software-properties-common sudo tzdata unzip vim wget zip \
    && rm -rf /var/lib/apt/lists/*

# Install Oracle JRE
RUN set -ex \
    && ln -s /usr/bin/update-alternatives /usr/sbin/alternatives \
    && ARCHIVE="`mktemp --suffix=.rpm`" \
    && curl -skL -j -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jre-8u191-linux-x64.rpm > $ARCHIVE \
    && DEBIAN_FRONTEND=noninteractive alien -i -k --scripts $ARCHIVE \
    && rm -rf $ARCHIVE

# Install Atlassian JIRA
RUN set -ex \
    && ARCHIVE="`mktemp --suffix=.tar.gz`" \
    && curl -skL $JIRA_DOWNLOAD_URL > $ARCHIVE \
    && mkdir -p $JIRA_CATALINA \
    && tar zxf $ARCHIVE --strip-components=1 -C $JIRA_CATALINA \
    && chown -Rf $JIRA_OWNER:$JIRA_GROUP $JIRA_CATALINA \
    && rm -rf $ARCHIVE

# Install MySQL Connector/J JAR
RUN set -ex \
    && ARCHIVE="`mktemp --suffix=.tar.gz`" \
    && curl -skL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.12.tar.gz > $ARCHIVE \
    && tar zxf $ARCHIVE --strip-components=1 -C $JIRA_CATALINA/lib/ mysql-connector-java-8.0.12/mysql-connector-java-8.0.12.jar \
    && rm -rf $ARCHIVE

# Install PostgreSQL JDBC JAR
RUN set -ex \
    && rm -rf $JIRA_CATALINA/lib/*postgresql*.jar \
    && curl -skL https://jdbc.postgresql.org/download/postgresql-42.2.4.jar > $JIRA_CATALINA/lib/postgresql-42.2.4.jar

# Install dumb-init
RUN set -ex \
    && curl -skL https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 > /usr/local/bin/dumb-init \
    && chmod 0755 /usr/local/bin/dumb-init

# Copy files
COPY files /

# Apply patches
RUN set -ex \
    && patch -d/ -p1 < /.patch

# Ensure required folders exist with correct owner:group
RUN set -ex \
    && mkdir -p $JIRA_HOME \
    && chown -Rf $JIRA_OWNER:$JIRA_GROUP $JIRA_HOME \
    && chmod 0755 $JIRA_HOME \
    && mkdir -p $JIRA_CATALINA \
    && chown -Rf $JIRA_OWNER:$JIRA_GROUP $JIRA_CATALINA \
    && chmod 0755 $JIRA_CATALINA
