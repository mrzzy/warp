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

# paths
BOX_DIR:=box
BUILD_DIR:=build
PACKER_DIR:=$(BOX_DIR)/packer
ANSIBLE_DIR=$(BOX_DIR)/ansible

# box metadata
BOX_NAME:=mrzzy/warp-box

# phony build rules
.PHONY: all box box-gcp clean fmt lint packer-init
.DEFAULT: all

all: box

lint:
	$(PACKER) init $(PACKER_DIR)
	$(PACKER) fmt -check $(PACKER_DIR)
	$(PACKER) validate $(PACKER_DIR)
	$(PRE_CMT) run

fmt:
	$(PACKER) fmt $(PACKER_DIR)

clean: clean-box

# build rules: WARP dev box VM
box: build/package.box

# development build: build box on virtualbox only.
build/package.box: $(PACKER_DIR) packer-init
	$(PACKER) build --only="vagrant.ubuntu" --force $<

box-gcp: $(PACKER_DIR) packer-init
	$(PACKER) build --only="googlecompute.ubuntu" --force $<

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
