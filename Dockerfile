FROM alpine:latest

# install software
RUN apk upgrade \
    && apk add bash curl nginx tzdata chrony-nts vnstat rrdtool \
    && apk cache clean 
RUN mkdir /www \
    && echo '*/10 * * * * bash /opt/chrony-network-stats.sh' >> /var/spool/cron/crontabs/root 

# copy entrypoint script
COPY ./src/startup.sh /opt/startup.sh
# copy chrony config
COPY ./config/chrony.conf:/etc/chrony.conf:ro
# copy stats script
COPY ./src/chrony-network-stats.sh /opt/chrony-network-stats.sh
COPY ./config/chrony-network-stats.conf /opt/chrony-network-stats.conf
# copy nginx site config
COPY ./config/chrony-nginx-stats.conf /etc/nginx/http.d/default.conf
COPY ./src/index.html /www/index.html
RUN chown -R nginx:www-data /www 


# set scrips to execuable
RUN chmod +x /opt/startup.sh && \
    chmod +x /opt/chrony-network-stats.sh

VOLUME /var/lib/chrony-rrd
VOLUME /var/lib/vnstat

# nginx standard port
EXPOSE 80
# ntp standard port
EXPOSE 123/udp

# check if it works
HEALTHCHECK CMD chronyc -n tracking || exit 1

# tell docker to run this at start
ENTRYPOINT [ "/bin/bash", "/opt/startup.sh" ]
