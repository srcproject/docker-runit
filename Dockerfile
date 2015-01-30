FROM debian:stable

MAINTAINER Unai Zalakain <contact@unaizalakain.info>

# Basic setup
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Install-Recommends "0"; \n\
APT::Get::Assume-Yes "true"; \n\
APT::Get::force-yes "true"; \n\
APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01buildconfig

# Update & upgrade
RUN apt-get update
RUN apt-get upgrade

# Install basic utilities
RUN apt-get install wget build-essential curl libssl-dev git

# Install user utilities
RUN apt-get install sudo tmux vim

# Setup user
RUN mkdir -p /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys

# Install SSH
RUN apt-get install openssh-server
RUN mkdir /var/run/sshd
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
EXPOSE 22

# Setup runit scripts
RUN apt-get install runit
RUN mkdir /etc/service/ssh && echo '#!/bin/sh\n\
exec /usr/sbin/sshd -D' > /etc/service/ssh/run
RUN chown root.root /etc/service/ssh/run
RUN chmod 750 /etc/service/ssh/run

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Launch runit
ENTRYPOINT ["/usr/sbin/runsvdir-start"]
