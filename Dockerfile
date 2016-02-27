#
#
#
#

FROM centos:latest

MAINTAINER Phillip Dudley version 0.1.0

# Install the required libraries
RUN yum install -y epel-release
RUN yum groupinstall -y "Development Tools"
RUN yum install -y openssl-devel pkgconfig gnutls-devel gnutls-utils vim cmake

# Create an IRC user to run the IRCd
RUN groupadd irc; useradd -g irc irc 
USER irc 

# Clone and checkout the tagged versions of InspIRCd and Anope
RUN cd ~; pwd; git clone https://github.com/anope/anope.git
RUN cd ~; pwd; git clone https://github.com/inspircd/inspircd.git
RUN cd ~/anope && git checkout 2.0.3
RUN cd ~/inspircd && git checkout v2.0.21
# Setup and build inspircd
RUN cd ~/inspircd; ./configure --enable-gnutls --enable-openssl --enable-epoll --enable-kqueue --prefix=/home/irc/ircd-build/
RUN cd ~/inspircd; make; make install 
# This might be changed to ADD and drop config files in there.
RUN cd ~/ircd-build; cp conf/examples/inspircd.conf.example conf/
# Setup and build Anope Services
RUN cd ~/anope; cmake  -DINSTDIR:STRING=/home/irc/anope-services -DRUNGROUP:STRING=irc -DDEFUMASK:STRING=007 -DCMAKE_BUILD_TYPE:STRING=RELEASE -DUSE_PCH:BOOLEAN=OFF    ..
RUN cd ~/anope/build; make; make install
