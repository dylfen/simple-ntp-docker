FROM alpine:latest

# install timezone data and chrony
RUN apk add --no-cache tzdata chrony

# ntp standard port
EXPOSE 123/udp

ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
