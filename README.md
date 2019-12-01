# tinc

[![Pipeline Status](https://gitlab.com/ix.ai/tinc/badges/master/pipeline.svg)](https://gitlab.com/ix.ai/tinc/)
[![Docker Stars](https://img.shields.io/docker/stars/ixdotai/tinc.svg)](https://hub.docker.com/r/ixdotai/tinc/)
[![Docker Pulls](https://img.shields.io/docker/pulls/ixdotai/tinc.svg)](https://hub.docker.com/r/ixdotai/tinc/)
[![Gitlab Project](https://img.shields.io/badge/GitLab-Project-554488.svg)](https://gitlab.com/ix.ai/tinc/)


Docker image for [tinc vpn](https://www.tinc-vpn.org/)

## Usage

Only at the first run is the configuration created. Subsequent runs will not change any existing configuration.

### Docker Swarm
```yml
services:
  tinc:
    image: ixdotai/tinc:latest
    ports:
      - "655:655/tcp"
      - "655:655/udp"
    volumes:
      - ./tinc:/etc/tinc
    environment:
      IP_ADDR: 1.2.3.4
      ADDRESS: 10.20.30.1
      NETMASK: 255.255.255.0
      NETWORK: 10.20.30.0/24
      RUNMODE: server
      VERBOSE: '2'
    cap_add:
      - NET_ADMIN
    dns:
      - 1.1.1.1
      - 1.0.0.1
    restart: always
```

### Generating client configuration

[...]

## Configuration

The configuration is created on the first run based on the environment variables. The keys are created on the first run as well.

### Environment

| **Variable**  | **Default**     | **Description**                                                                          |
|:--------------|:---------------:|:-----------------------------------------------------------------------------------------|
| `IP_ADDR`     | -               | *Mandatory if `RUNMODE` is `server`.* The IP address to which the clients should connect |
| `NETNAME`     | `tinc-network`  | The name of the network |
| `ADDRESS`     | `10.0.0.1`      | The IP address of this node in `NETNAME` |
| `NETMASK`     | `255.255.255.0` | The netmask of this node in `NETNAME` |
| `NETWORK`     | `10.0.0.0/24`   | The network address in `NETNAME` |
| `RUNMODE`     | `server`        | If not running as a server, set this to anything else |
| `VERBOSE`     | `0`             | See [tinc debug levels](https://www.tinc-vpn.org/documentation/Debug-levels.html) |

## Resources:
* GitLab: https://gitlab.com/ix.ai/tinc
* Docker Hub: https://hub.docker.com/r/ixdotai/tinc

## Credits
The scripts in this image are inspired by [vimagick/dockerfiles](https://github.com/vimagick/dockerfiles/tree/master/tinc).
