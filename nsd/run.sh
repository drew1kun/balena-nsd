#!/bin/sh

echo "${NSD_CFG}" | base64 -d > /etc/nsd/nsd.conf
echo "${NSD_ZONE_CFG}" | base64 -d > "/zones/${NSD_ZONE}.zone"
echo "${NSD_REV_ZONE_CFG}" | base64 -d > "/zones/${NSD_REV_ZONE}.zone"

/bin/sed -i "s/NSD_ZONE/${NSD_ZONE}/" /etc/nsd/nsd.conf
/bin/sed -i "s/NSD_REV_ZONE/${NSD_REV_ZONE}/" /etc/nsd/nsd.conf

if [ ! -f /etc/nsd/nsd_server.pem ]; then
  nsd-control-setup
fi

chown -R $UID:$GID /var/db/nsd/ /etc/nsd /tmp

exec /sbin/tini -- nsd -u $UID.$GID -P /tmp/nsd.pid -d
