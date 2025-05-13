# WARP

[![Build Status](https://github.com/mrzzy/warp/actions/workflows/box.yaml/badge.svg)](https://github.com/mrzzy/warp/actions/workflows/box.yaml)

Reproducible development environment.

## Introduction

WARP facilitates full recreation of my development environment (Dev Env) in different environments:

- **Playbooks** A set of Ansible Playbooks used to provision the Dev Env on a new computer / upgrade an existing computer.
- **Container** portable Docker Containers development environments
    - `ghcr.io/mrzzy/warp`: CLI based tooling only based on [TTYD](https://github.com/tsl0922/ttyd)
    - `ghcr.io/mrzzy/warp-gui`: GUI KDE desktop environment based on [Selkies](https://github.com/selkies-project/selkies).

## Usage

### Container

### CLI Container
Run the WARP container:

```sh
docker-compose up warp
```

Dev Env is now accessible via web browser at [http://localhost:7681](http://localhost:7681).

### GUI Container
```sh
docker-compose up warp_gui
```

Dev Env is now accessible via web browser at [http://localhost:8080](http://localhost:8080).

### Playbooks

1. Install the Pypi modules listed in `requirements.txt`

```sh
pip install -r requirements.txt
```

2. Install pre-commit hooks:

```sh
pre-commit install
```

3. Recreate WARP's development environment locally:

```
make apply
```

## License

MIT.
