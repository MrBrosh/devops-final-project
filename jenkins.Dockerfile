FROM jenkins/jenkins:lts

USER root

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      python3 \
      ansible \
      openssh-client \
    && curl -fsSL https://releases.hashicorp.com/terraform/1.15.5/terraform_1.15.5_linux_amd64.zip -o /tmp/terraform.zip \
    && unzip -o /tmp/terraform.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/terraform \
    && rm -f /tmp/terraform.zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

