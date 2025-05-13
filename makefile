#
# WARP
# project makefile
#

# program vars
CD:=cd
PRE_CMT:=pre-commit
RM:=rm -rf
GALAXY:=ansible-galaxy
PLAYBOOK:=ansible-playbook

# paths
BOX_DIR:=box
BUILD_DIR:=build
ANSIBLE_DIR=$(BOX_DIR)/ansible

# box metadata
BOX_NAME:=mrzzy/warp-box

# phony build rules
.PHONY: all box  clean lint apply  ansible-deps
.DEFAULT: all

all: box

box: $(BOX_DIR)
	cd $(BOX_DIR) && docker-compose build

lint: ansible-deps
	$(PRE_CMT) run

# apply the ansible devbox playbook to the local machine
ansible-deps:
	$(GALAXY) install --force -r $(ANSIBLE_DIR)/requirements.yaml

apply: $(ANSIBLE_DIR) ansible-deps
	$(PLAYBOOK) \
		--inventory 127.0.0.1, \
		--connection local \
		--ask-become-pass \
		$(ANSIBLE_DIR)/system.yaml
	$(PLAYBOOK) \
		--inventory 127.0.0.1, \
		--connection local \
		--ask-become-pass \
		$(ANSIBLE_DIR)/user.yaml

apply-gui: $(ANSIBLE_DIR) ansible-deps
	$(PLAYBOOK) \
		--inventory 127.0.0.1, \
		--connection local \
		--ask-become-pass \
		$(ANSIBLE_DIR)/gui_system.yaml
