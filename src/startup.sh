#!/bin/bash

# if nginx is installed, start nginx, vnstat and cron
if [ -f /usr/sbin/nginx ]; then
  vnstat --dbiflist 1 >/dev/null 2>&1 ||  { vnstatd --initdb; vnstat --add -i eth0; }
  nohup vnstatd -d
  nohup cp -f /www/index.wait /www/index.html
  nohup chown -R nginx:www-data /www 
  nohup nginx
  nohup crond -l 0 -L /var/log/crond.log
fi

CHRONY_CONFIG_FILE="/etc/chrony.conf"

# CHRONY_LOG_LEVEL environment variable. if empty, set to default 0
# levels: 0 = info - 1 = warn - 2 = non-fatal err - 3 = fatal err
if [ -z "${CHRONY_LOG_LEVEL}" ]; then
  CHRONY_LOG_LEVEL=0
fi
# confirm log level is between 0-3
if [ "${CHRONY_LOG_LEVEL}" -gt 3 ]; then
   # level over max, set to level 3
   CHRONY_LOG_LEVEL=3
fi

if [ -f /var/run/chrony/chronyd.pid ]; then
  rm -f /var/run/chrony/chronyd.pid
fi

# startup chronyd 
exec /usr/sbin/chronyd -x -d -u chrony -L ${CHRONY_LOG_LEVEL} -f ${CHRONY_CONFIG_FILE}
