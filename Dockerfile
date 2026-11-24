FROM alpine:latest

# upgrade and install timezone data and chrony
RUN apk upgrade && \
    apk add bash tzdata chrony-nts nginx vnstat rrdtool && \
    apk cache clean

# copy entrypoint script
COPY ./startup.sh /opt/startup.sh
COPY ./chrony-network-stats.sh /opt/chrony-network-stats.sh
COPY ./chrony-network-stats.conf /opt/chrony-network-stats.conf

# nginx standard port
EXPOSE 80/tcp
# ntp standard port
EXPOSE 123/udp

# check if it works
HEALTHCHECK CMD chronyc -n tracking || exit 1

ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
