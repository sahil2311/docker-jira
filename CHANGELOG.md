# Docker Image Packaging for Atlassian JIRA

## 7.13.x-0alvistack1 - TBC

### Major Changes

  - Run systemd service with specific system user
  - Explicitly set system user UID/GID

## 7.13.0-1alvistack1 - 2018-12-10

### Major Changes

  - Update base image to Ubuntu 18.04
  - Revamp deployment with Ansible roles
  - Replace Oracle Java with OpenJDK

## 7.12.3-0alvistack3 - 2018-10-29

### Major Changes

  - Handle changes with patch
  - Update dumb-init to v.1.2.2
  - Upgrade MySQL Connector/J and PostgreSQL JDBC support
  - Add TZ support
  - Add SESSION\_TIMEOUT support

## 7.8.0-0alvistack7 - 2018-03-11

### Major Changes

  - Simplify Docker image naming

## 7.8.0-0alvistack1 - 2018-02-28

  - Migrate from <https://github.com/alvistack/ansible-container-jira>
  - Pure Dockerfile implementation
  - Ready for both Docker and Kubernetes use cases
