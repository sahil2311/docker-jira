# Docker Image Packaging for Atlassian JIRA

## 8.3.x-0alvistack1 - TBC

### Major Changes

## 8.3.2-0alvistack3 - 2019-08-29

### Major Changes

  - Simplify parameters combination with `BAMBOO_VERSION`
  - Ensure required folders exist with correct owner:group
  - Prepend executable if command starts with an option
  - Improve `ENTRYPOINT` and `CMD`

## 8.1.1-0alvistack3 - 2019-05-20

### Major Changes

  - Bugfix "Build times out because no output was received"
  - Upgrade minimal Ansible support to 2.8.0

## 8.1.0-0alvistack2 - 2019-04-16

### Major Changes

  - Run systemd service with specific system user
  - Explicitly set system user UID/GID
  - Porting to Molecule based

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
