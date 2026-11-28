FROM alpine:latest

# install software
RUN apk upgrade && \
    apk add bash tzdata chrony-nts && \
    apk cache clean  

# copy entrypoint script
COPY ./src/startup.sh /opt/startup.sh
# copy chrony config
COPY ./config/chrony.conf /etc/chrony.conf

# set scrips to execuable
RUN chmod +x /opt/startup.sh 

# ntp standard port
EXPOSE 123/udp

# check if it works
HEALTHCHECK CMD chronyc -n tracking || exit 1

# tell docker to run this at start
ENTRYPOINT [ "/bin/bash", "/opt/startup.sh" ]
