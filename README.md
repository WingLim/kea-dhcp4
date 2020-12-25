# kea-dhcp4

![build](https://github.com/WingLim/kea-dhcp4/workflows/build/badge.svg)

Docker image for kea-dhcp4 with amd64, arm64 and arm32v7.

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
