# WARP

[![Build Status](https://github.com/mrzzy/warp/actions/workflows/box.yaml/badge.svg)](https://github.com/mrzzy/warp/actions/workflows/box.yaml)

Reproducible development environment.

## Introduction

WARP facilitates full recreation of my development environment (Dev Env) in different environments:

- **Playbooks** A set of Ansible Playbooks used to provision the Dev Env on a new computer / upgrade an existing computer.
- **Container** A portable Docker Container focusing on console-based tooling in the Dev environment.

## Usage

### Container

Run the WARP container:

```sh
docker run -v /var/run/docker.sock:/var/run/docker.sock \
    -p 2222:22 \
    -p 7681:7681 \
    ghcr.io/mrzzy/warp
```


Dev Env is now accessible via web browser at [http://localhost:7681](http://localhost:7681).

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
