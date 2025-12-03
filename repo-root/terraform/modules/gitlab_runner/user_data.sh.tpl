#!/bin/bash
exec > /var/log/user-data-runner.log 2>&1
set -euxo pipefail

GITLAB_URL="${gitlab_url}"
REGISTRATION_TOKEN="${registration_token}"
RUNNER_TAGS="${runner_tags}"

export DEBIAN_FRONTEND=noninteractive

########################
# 기본 패키지 & 업데이트
########################
apt-get update -y
apt-get upgrade -y || true

########################
# Docker 설치
########################
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  apt-transport-https \
  software-properties-common

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

########################
# SSM Agent 설치
########################
snap install amazon-ssm-agent --classic
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

########################
# GitLab Runner 설치
########################
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash
apt-get install -y gitlab-runner

systemctl enable gitlab-runner
systemctl start gitlab-runner

########################
# Runner 자동 등록
########################
gitlab-runner register --non-interactive \
  --url "$GITLAB_URL" \
  --registration-token "$REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --description "tools-runner-01" \
  --tag-list "$RUNNER_TAGS" \
  --run-untagged="true" \
  --locked="false"

systemctl restart gitlab-runner
