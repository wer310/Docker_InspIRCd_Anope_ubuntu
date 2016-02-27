#
#
#
#

FROM centos:latest

MAINTAINER Phillip Dudley version 0.1.0

RUN yum install -y epel-release
RUN yum groupinstall -y "Development Tools"

RUN cd ~; pwd; git clone https://github.com/anope/anope.git
RUN cd ~; pwd; git clone https://github.com/inspircd/inspircd.git

RUN cd ~/anope && git checkout 2.0.3
RUN cd ~/inspircd && git checkout v2.0.21

