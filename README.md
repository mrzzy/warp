# WARP

[![Build Status](https://github.com/mrzzy/warp/actions/workflows/box.yaml/badge.svg)](https://github.com/mrzzy/warp/actions/workflows/box.yaml)

Reproducible development environment.

## Introduction

WARP facilitates full recreation of my development environment (Dev Env) in different environments:

- **Playbooks** A set of Ansible Playbooks used to provision the Dev Env on a new computer / upgrade an existing computer.
- **Container** portable Docker Container development environment:
    - `ghcr.io/mrzzy/warp`: CLI based tooling only based on [TTYD](https://github.com/tsl0922/ttyd)

## Usage

Run the WARP container & obtain a shell:

```sh
docker-compose up warp -d
docker-compose exec warp sudo -u ubuntu /home/ubuntu/.local/bin/zsh
```

Alternatively, the Dev Env is also accessible via web browser at [http://localhost:7681](http://localhost:7681).
