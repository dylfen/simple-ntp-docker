FROM alpine:latest

# upgrade and install timezone data and chrony
RUN apk upgrade && \
    apk add bash tzdata chrony && \
    apk cache clean

# copy entrypoint script
COPY ./startup.sh /opt/startup.sh

# ntp standard port
EXPOSE 123/udp

# check if it works
HEALTHCHECK CMD chronyc -n tracking || exit 1

ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
