FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server

# Install curl, nano and sudo
RUN apt-get install curl -y && apt-get install sudo -y && apt-get install nano

# Install python virtual environments
RUN apt install -y python3-venv

# Install the azure client
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install the azure cli tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs 2>/dev/null)-prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get update && apt-get install azure-functions-core-tools-4

# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'root:your_password' | chpasswd
RUN echo 'ubuntu:your_password' | chpasswd

# Allow root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

WORKDIR /home/ubuntu/app

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
