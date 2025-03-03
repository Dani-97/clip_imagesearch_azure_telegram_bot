FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server

# Install curl, nano and sudo
RUN apt-get install curl -y && apt-get install sudo -y && apt-get install nano

# Install the azure client
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

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
