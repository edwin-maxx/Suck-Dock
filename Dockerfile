# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server sudo curl wget git ca-certificates gnupg figlet \
    && rm -rf /var/lib/apt/lists/*

# -----------------------
# Install Node.js (LATEST LTS)
# -----------------------
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# SSH setup
RUN mkdir -p /var/run/sshd && \
    echo "Port 2222" >> /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# User
RUN useradd -m -s /bin/bash redwan && \
    echo "redwan:devastinglord" | chpasswd && \
    usermod -aG sudo redwan && \
    echo "redwan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/redwan

# Bash banner
RUN echo 'clear' >> /home/redwan/.bashrc && \
    echo 'echo -e "\033[1;35m$(figlet -c Tetroxide)\033[0m"' >> /home/redwan/.bashrc && \
    echo 'echo -e "\033[1;36m⚡ Welcome Redwan ⚡\033[0m"' >> /home/redwan/.bashrc && \
    chown redwan:redwan /home/redwan/.bashrc

# App files
WORKDIR /app
COPY server.js /app/server.js

# Ports
EXPOSE 2222
EXPOSE 3000

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
