Balena NSD
=========

[![MIT licensed][mit-badge]][mit-link]

Run an authoritative DNS server on Raspberry pi zero/one (or other devices with arm32v6 cpu architecture)

Inspired by:
------------

 - [balena-pihole][balena-pihole-link]
 - [hardware/nsd-dnssec][nsd-dnssec-link]
 - [offtechnologies/docker-arm32v6-nsd][docker-arm32v6-nsd-link]

What is this?
-------------

The project is a [balenaCloud][balenacloud-link] stack with the following services:

 - [NSD][nsd-link] -  an authoritative only, high performance, simple and open source name server.

Installation
------------
 - Go to your [balenaCloud][balenacloud-link] account (register the one if you do not have it yet) and create new application (name it for instance: pi-nsd)
 - Click 'Add device' under newly created application and choose Raspberry pi zero on one as the device type.
 - Choose the BalenaOS version and download the image.
 - Burn BalenaOS to your Raspberry pi SD card (using [BalenaEtcher][balenaEtcher-link] app).
 - Install [balena-cli][balena-cli-link] on your workstation.
 - Insert the SD card to you Raspberry pi and connect it to the network.
 - Wait until the new device appears as 'online' in your BalenaCloud account.
 - Authenticate against your BalenaCloud account with your balena-cli:

 ```bash
 balena login
 ```
 - Clone this project and go inside it's dir:

 ```bash
 git clone git@github.com:drew-kun/balena-nsd.git
 cd balena-nsd
 ```
- push the project to your device using balena-cli:

 ```bash
 # balena push <your_balena_app_name>
 # in our case:
 balena push pi-nsd
 ```
At this point you should run your pi-nsd server ready to be configured.

Configuration with Environment Variables
--------------

Since at this time balena does not allow docker bind mounts, we have to use Environment Variables in order to generate our NSD configuration.

These variables should be put to the `docker-compose.yml` or to `Balena Cloud UI` console into `Device Variables` (which have
higher priority then docker-compose.yml) or to the `Device Service Variables` (which have highest priority)

| Variable | Description | Default |
|----------|-------------|---------|
| **NSD_CFG** | base64 encoded contents of `/etc/nsd/nsd.conf` file |
| **NSD_ZONE** | zone filename (e.g.: `domain.tld`) - will be created in `/zone` dir within container |
| **NSD_ZONE_CFG** | base64 encoded contents of `/zone/${NSD_ZONE}.zone` file (see [here][nsd-dnssec-link]) |
| **NSD_REV_ZONE** | reverse zone filename file (e.g.: `2.168.192.in-addr.arpa`) - will be created in `/zone` dir within container |
| **NSD_REV_ZONE_CFG** | base64 encoded contents of reverse zone `/zone/${NSD_REV_ZONE}.zone` file |

These variables are hardcoded in nsd/run.sh docker container's entrypoint shell script.
Therefore, feel free to modify it's content as you wish, adding more zones (and the corresponding Environment Variables)

In order to create the content of these entries, take your nsd.conf and zonefiles (see the examples [here][nsd-dnssec-link],
and encode them into base64 for instance with the following command:

```bash
base64 nsd.conf
base64 domain.tld.zone
base64 2.168.192.in-addr.arpa.zone

```

License
-------

[MIT][mit-link]

Author Information
------------------

Andrew Shagayev | [e-mail](mailto:drewshg@gmail.com)

[mit-badge]: https://img.shields.io/badge/license-MIT-blue.svg
[mit-link]: https://raw.githubusercontent.com/drew-kun/ansible-dnscrypt/master/LICENSE

[balena-pihole-link]: https://github.com/klutchell/balena-pihole
[nsd-dnssec-link]: https://github.com/hardware/nsd-dnssec
[docker-arm32v6-nsd-link]: https://github.com/offtechnologies/docker-arm32v6-nsd
[balenacloud-link]: https://www.balena.io/cloud
[nsd-link]: https://en.wikipedia.org/wiki/NSD
[balenaEtcher-link]: https://www.balena.io/etcher/
[balena-cli-link]: https://www.balena.io/docs/reference/balena-cli/
