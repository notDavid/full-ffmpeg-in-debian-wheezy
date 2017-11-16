# build/install ffmpeg snapshot (currently v2.2)
#
# VERSION 0.0.1

FROM debian:latest
MAINTAINER notDavid <https://github.com/notDavid>

#ffmpeg build info: http://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

ENV HOME /root

ADD         buildffmpeg.sh /tmp/
RUN         chmod +x /tmp/buildffmpeg.sh
RUN         /tmp/buildffmpeg.sh
