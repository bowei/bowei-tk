FROM alpine
MAINTAINER Bowei Du bowei@google.com
RUN apk update
RUN apk add bind-tools
RUN apk add curl
RUN apk add iperf
RUN apk add git
RUN apk add python
RUN apk add vim
