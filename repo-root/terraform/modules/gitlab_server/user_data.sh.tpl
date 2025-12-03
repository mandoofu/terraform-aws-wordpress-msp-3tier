#!/bin/bash
exec > /var/log/user-data-gitlab.log 2>&1
set -euxo pipefail

# Terraform 템플릿 변수 → bash 변수로 치환
GITLAB_HOSTNAME="${gitlab_hostname}"

export DEBIAN_FRONTEND=noninteractive

########################
# 기본 패키지 & 업데이트
########################
apt-get update -y
apt-get upgrade -y || true

apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  apt-transport-https \
  software-properties-common

########################
# Docker 설치
########################
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
# GitLab 컨테이너 구성
########################
mkdir -p /srv/gitlab

cat >/srv/gitlab/docker-compose.yml <<EOF
version: "3.8"

services:
  web:
    image: "gitlab/gitlab-ce:latest"
    restart: always
    hostname: "$GITLAB_HOSTNAME"
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url "http://$GITLAB_HOSTNAME"
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
    ports:
      - "80:80"
      - "443:443"
      - "2222:22"
    volumes:
      - "/srv/gitlab/config:/etc/gitlab"
      - "/srv/gitlab/logs:/var/log/gitlab"
      - "/srv/gitlab/data:/var/opt/gitlab"
EOF

cd /srv/gitlab
/usr/bin/docker compose pull || /usr/bin/docker-compose pull
/usr/bin/docker compose up -d || /usr/bin/docker-compose up -d
