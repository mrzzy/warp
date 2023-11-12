#
# WARP
# project makefile
#

# program vars
CD:=cd
VAGRANT:=vagrant
PACKER:=packer
PRE_CMT:=pre-commit
RM:=rm -rf
GALAXY:=ansible-galaxy
PLAYBOOK:=ansible-playbook

# paths
BOX_DIR:=box
BUILD_DIR:=build
PACKER_DIR:=$(BOX_DIR)/packer
ANSIBLE_DIR=$(BOX_DIR)/ansible

# box metadata
BOX_NAME:=mrzzy/warp-box

# phony build rules
.PHONY: all box box-gcp clean fmt lint apply packer-init ansible-deps
.DEFAULT: all

all: box

lint: packer-init ansible-deps
	$(PACKER) fmt -check $(PACKER_DIR)
	$(PACKER) validate $(PACKER_DIR)
	$(PRE_CMT) run

fmt:
	$(PACKER) fmt $(PACKER_DIR)

clean: clean-box

# apply the ansible devbox playbook to the local machine
ansible-deps:
	$(GALAXY) install -r requirements.yaml

apply: $(ANSIBLE_DIR) ansible-deps
	$(PLAYBOOK) \
		--inventory 127.0.0.1, \
		--connection local \
		--ask-become-pass \
		$(ANSIBLE_DIR)/console.yaml

apply-gui: $(ANSIBLE_DIR) ansible-deps
	$(PLAYBOOK) \
		--inventory 127.0.0.1, \
		--connection local \
		--ask-become-pass \
		$(ANSIBLE_DIR)/gui.Yaml

# applying on laptop requires an inventory file due to required variables for borgbackup role
apply-laptop: $(ANSIBLE_DIR) ansible-deps
	$(PLAYBOOK) \
		--inventory inventory.yaml \
		--connection local \
		--ask-become-pass \
		$(ANSIBLE_DIR)/laptop.yaml

# development build: build box on virtualbox only.
box: $(PACKER_DIR) packer-init ansible-deps
	$(PACKER) build -var ansible_playbook=box/ansible/gui.yaml \
		--on-error=ask --only="vagrant.ubuntu_vm" --force $<

box-gcp: $(PACKER_DIR) packer-init ansible-deps
	$(PACKER) build --only="googlecompute.ubuntu_gce" --force $<

packer-init: $(PACKER_DIR)
	$(PACKER) init $<

clean-box:
	$(RM) $(BUILD_DIR)

install-box: build/package.box
	$(VAGRANT) box add build/package.box --name $(BOX_NAME) --force

uninstall-box:
	$(VAGRANT) box remove $(BOX_NAME)

# use the Vagrantfile generated by packer to bring the box VM up
# the name of the machine is 'output', set by the Vagrantfile
run-box: install-box
	$(CD) $(BUILD_DIR) && $(VAGRANT) up
	-$(CD) $(BUILD_DIR) && $(VAGRANT) ssh output
	$(CD) $(BUILD_DIR) && $(VAGRANT) destroy
