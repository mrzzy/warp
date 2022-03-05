# WARP
:construction: write code anywhere in the interwebs

## Introduction
WARP is WIP unified development environment for writing code anywhere:
- Cloud Native: Powered by cloud computing.
- Portable: Work anywhere with a web browser and an internet connection.
- Transparent: Nested-VMs and Docker should work transparently.
- Cost Effective: Environment shuts off when you are not using it.

## Development
### WARP:Box
#### Tooling
Install WARP:Box development tooling:
1. Install [Packer](https://www.packer.io/downloads) & [Vagrant](https://www.vagrantup.com/downloads)
2. Install Ansible & Code Linters in a Python virtualenv:

```sh
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

3. Install pre-commit hooks:

```sh
pre-commit install-hooks
pre-commit install
```

:tada: Happy Hacking
