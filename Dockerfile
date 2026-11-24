FROM alpine:latest

# upgrade and install timezone data and chrony
RUN apk upgrade && \
    apk add bash tzdata chrony-nts nginx vnstat rrdtool && \
    apk cache clean

# copy entrypoint script
COPY ./startup.sh /opt/startup.sh
# copy stats script
COPY ./chrony-network-stats.sh /opt/chrony-network-stats.sh
# copy cron job script to "run every 15 min" folder
COPY ./cron-stats /etc/periodic/15min/cron-stats

# set scrips to execuable
RUN chmod +x /opt/startup.sh
RUN chmod +x /opt/chrony-network-stats.sh
RUN chmod +x /etc/periodic/15min/cron-stats

# nginx standard port
EXPOSE 80
# ntp standard port
EXPOSE 123/udp

# check if it works
HEALTHCHECK CMD chronyc -n tracking || exit 1

# tell docker to run this at start
ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
