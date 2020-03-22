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
| **NSD_CFG** | base64 encoded contents of `/etc/nsd/nsd.conf` file | c2VydmVyOgogIHNlcnZlci1jb3VudDogMQogIGlwNC1vbmx5OiB5ZXMKICBoaWRlLXZlcnNpb246IHllcwogIGlkZW50aXR5OiAiIgogIHpvbmVzZGlyOiAiL3pvbmVzIgoKcmVtb3RlLWNvbnRyb2w6CiAgY29udHJvbC1lbmFibGU6IHllcwoKem9uZToKICBuYW1lOiAiTlNEX1pPTkUiCiAgem9uZWZpbGU6ICJOU0RfWk9ORS56b25lIgoKem9uZToKICBuYW1lOiAiTlNEX1JFVl9aT05FIgogIHpvbmVmaWxlOiAiTlNEX1JFVl9aT05FLnpvbmUiCga== |
| **NSD_ZONE** | zone filename - will be created in `/zone` dir within container | `domain.tld` |
| **NSD_ZONE_CFG** | base64 encoded contents of `/zone/${NSD_ZONE}.zone` file (see [here][nsd-dnssec-link]) | JE9SSUdJTiBkb21haW4udGxkLgokVFRMIDcyMDAKCjsgU09BCgpAICAgICAgIElOICAgICAgU09BICAgIG5zMS5kb21haW4udGxkLiBob3N0bWFzdGVyLmRvbWFpbi50bGQuICgKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDIwMTYwMjAyMDIgOyBTZXJpYWwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDcyMDAgICAgICAgOyBSZWZyZXNoCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxODAwICAgICAgIDsgUmV0cnkKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDEyMDk2MDAgICAgOyBFeHBpcmUKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDg2NDAwICkgICAgOyBNaW5pbXVtCgo7IE5BTUVTRVJWRVJTCgpAICAgICAgICAgICAgICAgICAgIElOICAgICAgICAgICAgICAgIE5TICAgICAgICAgICAgICAgICAgIG5zMS5kb21haW4udGxkLgpAICAgICAgICAgICAgICAgICAgIElOICAgICAgICAgICAgICAgIE5TICAgICAgICAgICAgICAgICAgIG5zMi5kb21haW4udGxkLgpAICAgICAgICAgICAgICAgICAgIElOICAgICAgICAgICAgICAgIE5TICAgICAgICAgICAgICAgICAgIG5zMy5kb21haW4udGxkLgoKOyBBIFJFQ09SRFMKCm5zMSAgICAgICAgICAgICAgICAgSU4gICAgICAgICAgICAgICAgQSAgICAgICAgICAgICAgICAgICAgMTkyLjE2OC4yLjEKbnMyICAgICAgICAgICAgICAgICBJTiAgICAgICAgICAgICAgICBBICAgICAgICAgICAgICAgICAgICAxOTIuMTY4LjIuMgpuczIgICAgICAgICAgICAgICAgIElOICAgICAgICAgICAgICAgIEEgICAgICAgICAgICAgICAgICAgIDE5Mi4xNjguMi4zCm5hcyAgICAgICAgICAgICAgICAgSU4gICAgICAgICAgICAgICAgQSAgICAgICAgICAgICAgICAgICAgMTkyLjE2OC4yLjQKcm91dGVyICAgICAgICAgICAgICBJTiAgICAgICAgICAgICAgICBBICAgICAgICAgICAgICAgICAgICAxOTIuMTY4LjIuMjU0Cgo7IENOQU1FIFJFQ09SRFMKCmdhdGV3YXkgICAgICAgICAgICAgICAgIElOICAgICAgICAgICAgICAgIENOQU1FICAgICAgICAgICAgICAgIHJvdXRlcgo= |
| **NSD_REV_ZONE** | reverse zone filename file - will be created in `/zone` dir within container | `2.168.192.in-addr.arpa` |
| **NSD_REV_ZONE_CFG** | base64 encoded contents of reverse zone `/zone/${NSD_REV_ZONE}.zone` file | O3pvbmUgZmlsZSBmb3IgMTkyLjE2OC4yLjAvMjQgLS0gZG9tYWluLnRsZCByZXZlcnNlIGxvb2t1cAokVFRMIDEwczsgMTAgc2VjcyBkZWZhdWx0IFRUTCBmb3Igem9uZQoyLjE2OC4xOTIuaW4tYWRkci5hcnBhLiBJTiAgICAgIFNPQSAgICAgbnMxLmRvbWFpbi50bGQuIGhvc3RtYXN0ZXIuZG9tYWluLnRsZC4gKAogICAgICAgICAgICAgICAgICAgICAgICAyMDE2MDMwMTAxICAgIDsgc2VyaWFsIG51bWJlciBvZiBab25lIFJlY29yZAogICAgICAgICAgICAgICAgICAgICAgICAxMjAwcyAgICAgICAgIDsgcmVmcmVzaCB0aW1lCiAgICAgICAgICAgICAgICAgICAgICAgIDE4MHMgICAgICAgICAgOyByZXRyeSB0aW1lIG9uIGZhaWx1cmUKICAgICAgICAgICAgICAgICAgICAgICAgMWQgICAgICAgICAgICA7IGV4cGlyYXRpb24gdGltZQogICAgICAgICAgICAgICAgICAgICAgICAzNjAwICAgICAgICAgIDsgY2FjaGUgdGltZSB0byBsaXZlCiAgICAgICAgICAgICAgICAgICAgICAgICkKCjtOYW1lIHNlcnZlcnMgZm9yIHRoaXMgZG9tYWluCjIuMTY4LjE5Mi5pbi1hZGRyLmFycGEuICAgICAgICAgSU4gICAgICBOUyAgICAgICBkb21haW4udGxkLgoKO0lQIHRvIEhvc3RuYW1lIFBvaW50ZXJzCjEuMi4xNjguMTkyLmluLWFkZHIuYXJwYS4gICAgICAgSU4gICAgICBQVFIgICAgICBuczEuZG9tYWluLnRsZC4KMi4yLjE2OC4xOTIuaW4tYWRkci5hcnBhLiAgICAgICBJTiAgICAgIFBUUiAgICAgIG5zMi5kb21haW4udGxkLgozLjIuMTY4LjE5Mi5pbi1hZGRyLmFycGEuICAgICAgIElOICAgICAgUFRSICAgICAgbnMzLmRvbWFpbi50bGQuCjQuMi4xNjguMTkyLmluLWFkZHIuYXJwYS4gICAgICAgSU4gICAgICBQVFIgICAgICBuYXMuZG9tYWluLnRsZC4KMjU0LjIuMTY4LjE5Mi5pbi1hZGRyLmFycGEuICAgICBJTiAgICAgIFBUUiAgICAgIHJvdHVlci5kb21haW4udGxkLgo= |

These variables are hardcoded in nsd/run.sh docker container's entrypoint shell script.
Therefore, feel free to modify it's content as you wish, adding more zones (and the corresponding Environment Variables)

Default base64 encoded content of `/etc/nsd/nsd.conf` (**NSD_CFG**):

```yaml
server:
  server-count: 1
  ip4-only: yes
  hide-version: yes
  identity: ""
  zonesdir: "/zones"

remote-control:
  control-enable: yes

zone:
  name: "NSD_ZONE"
  zonefile: "NSD_ZONE.zone"

zone:
  name: "NSD_REV_ZONE"
  zonefile: "NSD_REV_ZONE.zone"
```

Default base64 encoded content of `/zones/domain.tld.zone` forward zone (**NSD_ZONE_CFG**):

```
$ORIGIN domain.tld.
$TTL 7200

; SOA

@       IN      SOA    ns1.domain.tld. hostmaster.domain.tld. (
                                        2016020202 ; Serial
                                        7200       ; Refresh
                                        1800       ; Retry
                                        1209600    ; Expire
                                        86400 )    ; Minimum

; NAMESERVERS

@                   IN                NS                   ns1.domain.tld.
@                   IN                NS                   ns2.domain.tld.
@                   IN                NS                   ns3.domain.tld.

; A RECORDS

ns1                 IN                A                    192.168.2.1
ns2                 IN                A                    192.168.2.2
ns2                 IN                A                    192.168.2.3
nas                 IN                A                    192.168.2.4
router              IN                A                    192.168.2.254

; CNAME RECORDS

gateway                 IN                CNAME                router
```

Default base64 encoded content of `/zones/2.168.192.in-addr.arpa.zone` reverse zone (**NSD_REV_ZONE_CFG**):

```
;zone file for 192.168.2.0/24 -- domain.tld reverse lookup
$TTL 10s; 10 secs default TTL for zone
2.168.192.in-addr.arpa. IN      SOA     ns1.domain.tld. hostmaster.domain.tld. (
                        2016030101    ; serial number of Zone Record
                        1200s         ; refresh time
                        180s          ; retry time on failure
                        1d            ; expiration time
                        3600          ; cache time to live
                        )

;Name servers for this domain
2.168.192.in-addr.arpa.         IN      NS       domain.tld.

;IP to Hostname Pointers
1.2.168.192.in-addr.arpa.       IN      PTR      ns1.domain.tld.
2.2.168.192.in-addr.arpa.       IN      PTR      ns2.domain.tld.
3.2.168.192.in-addr.arpa.       IN      PTR      ns3.domain.tld.
4.2.168.192.in-addr.arpa.       IN      PTR      nas.domain.tld.
254.2.168.192.in-addr.arpa.     IN      PTR      rotuer.domain.tld.
```

Create DNSSEC configuration
------------------------

In order to create the base64 content of **_CFG** variables, first create your zones config files (see the examples [here][nsd-dnssec-link].

Encode them, for instance, with the following command:

```bash
base64 domain.tld.zone
base64 2.168.192.in-addr.arpa.zone
```
NOTE: at least when doing it on mac, make sure your files have an empty line at the end, otherwise base64 encoded files appear broken in the container.

Put them into corresponding Environment Variables **NSD_ZONE_CFG** and **NSD_REV_ZONE_CFG** in your BalenCloud account (under `Device Variables` or `Device Service Variables`)

Go the nsd container:

```bash
#balena ssh <IP_ADDRESS_OF_DEVICE> <CONTAINER_NAME>
balena ssh 192.168.2.5 nsd
```
Or just use BalenaCloud UI for that...

Check the zone configuration files syntax (just a good practice):

```bash
cd /zones/

# nsd-checkzone <ZONE> <ZONE_FILE>
nsd-checkzone domain.tld ./domain.tld.zone
zone domain.tld is ok

nsd-checkzone 2.168.192.in-addr.arpa 2.168.192.in-addr.arpa.zone
zone 2.168.192.in-addr.arpa is ok
```

To use dnssec, generate ZSK and KSK keys for your domain:

```bash
#keygen <DOMAIN>
keygen domain.tld
```

This will generate key files in the /zones/ volume directory.
Then sign your dns zone (default expiration date is 1 month):

```bash
# signzone <DOMAIN>
signzone domain.tld

Signing zone for domain.tld
NSD configuration rebuild... reconfig start, read /etc/nsd/nsd.conf
ok
Reloading zone for domain.tld... ok
Notify slave servers... ok
Done.

# or set custom RRSIG RR expiration date :
signzone domain.tld [YYYYMMDDhhmmss]
signzone domain.tld 20170205220210
```
As a result new `.zone.signed` files will be created in the `/zones/` volume.

Modify your /etc/nsd/nsd.conf by changing zonefiles to newly created `*.zone.signed` files:

```yaml
zone:
  name: "domain.tld"
  zonefile: "domain.tld.zone.signed"

zone:
  name: "2.168.192.in-addr.arpa"
  zonefile: "2.168.192.in-addr.arpa.zone.signed"
```

Finally, convert your recently changed `/etc/nsd/nsd.conf` to base64 and put to your BalenCloud account (under `Device Variables` or `Device Service Variables`)

Check your DNSSEC configuration
-------------------------------

To show your DS-Records (Delegation Signer), within container do:

```bash
ds-records domain.tld

> DS record 1 [Digest Type = SHA1] :
domain.tld. 600 IN DS xxxx 14 1 xxxxxxxxxxxxxx

> DS record 2 [Digest Type = SHA256] :
domain.tld. 600 IN DS xxxx 14 2 xxxxxxxxxxxxxx

> Public KSK Key :
domain.tld. IN DNSKEY 257 3 14 xxxxxxxxxxxxxx ; {id = xxxx (ksk), size = 384b}
```

Update your zonefiles
---------------------

- Update **NSD_ZONE_CFG** and/or **NSD_REV_ZONE_CFG**
- Go inside the container, remove old `*.zone.signed` files and sign new zones
- Restart the service

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
