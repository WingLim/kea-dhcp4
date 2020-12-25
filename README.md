# kea-dhcp4

![build](https://github.com/WingLim/kea-dhcp4/workflows/build/badge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/winglim/kea-dhcp4?logo=docker)](https://hub.docker.com/r/winglim/kea-dhcp4)
[![github package](https://img.shields.io/static/v1?label=WingLim&message=GITHUB%20PACKAGE&color=blue&logo=github)](https://github.com/users/WingLim/packages/container/package/kea-dhcp4)

Docker image for kea-dhcp4 with amd64, arm64 and arm32v7.

**NOTICE: For building image with arm architecture, I use alpine:edge as base image, it will turn to release version when it includes kea-dhcp package.**

## Usage

### Use memfile

Create dir and files.

```shell
mkdir -p kea-dhcp4/conf
cd kea-dhcp4
touch conf/kea-dhcp4.conf
touch dhcp4.leases
touch docker-compose.yml
```

`docker-compose.yml`:

```yaml
version: "3"
services:
  kea-dhcp4:
    image: ghcr.io/winglim/kea-dhcp4
    volumes:
      - "$PWD/conf/kea-dhcp4.conf:/etc/kea/kea-dhcp4.conf"
      - "$PWD/conf/dhcp4.leases:/var/lib/kea/dhcp4.leases"
    restart: always
    network_mode: host
    container_name: kea-dhcp4
```

`conf/kea-dhcp4.conf`:

For more DHCP4 settings: [https://kea.readthedocs.io/en/kea-1.8.1/arm/dhcp4-srv.html](https://kea.readthedocs.io/en/kea-1.8.1/arm/dhcp4-srv.html)

```json
{
  "Dhcp4": {
    "valid-lifetime": 43200,
    "renew-timer": 1000,
    "rebind-timer": 2000,

    "interfaces-config": {
      "interfaces": ["eth0"]
    },

    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/lib/kea/dhcp4.leases"
    },

    "subnet4": [
      {
        "subnet": "192.168.1.0/24",
        "pools": [
          {
            "pool": "192.168.1.1 - 192.168.1.255"
          }
        ]
      }
    ]
  }
}
```

### Use MariaDB

**NOTICE: I use `kea-admin` to initialize the database, it may take some time, please be patient**

`docker-compose.yml`:

Use `latest-mariadb` tag.

```yaml
version: "3"
services:
  kea-dhcp4:
    image: ghcr.io/winglim/kea-dhcp4:latest-mariadb
    volumes:
        - "$PWD/conf/kea-dhcp4.conf:/etc/kea/kea-dhcp4.conf"
        - "$PWD/conf/dhcp4.leases:/var/lib/kea/dhcp4.leases"
    restart: always
    network_mode: host
    container_name: kea-dhcp4
  
  mariadb:
    image: yobasystems/alpine-mariadb
    environment:
      - MYSQL_DATABASE=keadhcp4
      - MYSQL_ROOT_PASSWORD=keapassword
      - MYSQL_USER=keauser
      - MYSQL_PASSWORD=keapassword
    volumes:
      - '$PWD/conf/db:/var/lib/mysql'
    ports:
      - 3306:3306
    restart: always
    container_name: kea-mariadb

```

Edit `lease-database` part in  `conf/kea-dhcp4.conf`:

```json
"lease-database": {
    "type": "mysql",
    "host": "127.0.0.1",
    "port": 3306,
    "name": "keadhcp4",
    "user": "keauser",
    "password": "keapassword"
}
```
