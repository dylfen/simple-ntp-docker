#!/bin/sh

CHRONY_CONFIG_FILE="/etc/chrony.conf"

# CHRONY_LOG_LEVEL environment variable. if empty, set to default 0
# levels: 0 = info - 1 = warn - 2 = non-fatal err - 3 = fatal err
if [ -z "${CHRONY_LOG_LEVEL}"]; then
  CHRONY_LOG_LEVEL=0
fi
# confirm log level is between 0-3
if ["${CHRONY_LOG_LEVEL}" -gt 3]; then
   # level over max, set to level 3
   CHRONY_LOG_LEVEL=3
fi

# startup chronyd 
exec /usr/sbin/chronyd -x -d -u chrony -L ${CHRONY_LOG_LEVEL} -f ${CHRONY_CONFIG_FILE}
