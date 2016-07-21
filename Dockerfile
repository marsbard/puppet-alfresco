FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV uid 1000
ENV gid 1000

# TODO check if PUPPET_URL can include $PUPPET_PACKAGE so DRY
ENV PUPPET_PACKAGE puppetlabs-release-pc1-xenial.deb
ENV PUPPET_URL http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb

ENV SHELL bash

RUN apt-get update && apt-get install --no-install-recommends -y wget git ca-certificates

RUN wget --no-check-certificate $PUPPET_URL
RUN dpkg -i $PUPPET_PACKAGE


#RUN git -c http.sslVerify=false clone http://github.com/marsbard/puppet-alfresco.git
RUN git clone http://github.com/marsbard/puppet-alfresco.git

WORKDIR puppet-alfresco



ENTRYPOINT ./install.sh
