#!/bin/bash

nsd_cfg='/etc/nsd/nsd.conf'
zones_path='/zones'
sed_path='/bin/sed'

# Generate default nsd.config template:
echo "${NSD_BASE64_CFG}" | base64 -d > "${nsd_cfg}"

# Configure DNS zones:
for i in 0 1 2 3 4
do
    zone="NSD_ZONE_${i}"
    zone_cfg="NSD_BASE64_ZONE_${i}_CFG"
    zone_signed="NSD_ZONE_${i}_SIGNED"

    # Create zone config files:
    echo "${!zone_cfg}" | base64 -d > "${zones_path}/${!zone}.zone"

    # Specify correct zone configs in nsd.conf:
    if [ "${!zone_signed}" == true ]; then
        "${sed_path}" -i "s/\(${zone}.zone\)/\1.signed/" "${nsd_cfg}"
    fi
    "${sed_path}" -i "s/${zone}/${!zone}/" "${nsd_cfg}"
done

# Start NSD:
if [ ! -f /etc/nsd/nsd_server.pem ]; then
  nsd-control-setup
fi
chown -R $UID:$GID /var/db/nsd/ /etc/nsd /tmp
exec /sbin/tini -- nsd -u $UID.$GID -P /tmp/nsd.pid -d
