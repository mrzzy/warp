#
# WARP
# project makefile
#

# program vars
VAGRANT:=vagrant
PACKER:=packer
ANSIBLE_LINT:=ansible-lint
CODESPELL:=codespell
RM:=rm -rf

# paths
BOX_DIR:=box
PACKER_DIR:=$(BOX_DIR)/packer
ANSIBLE_DIR=$(BOX_DIR)/ansible

# phony build rules
.PHONY: all box clean fmt lint
.DEFAULT: all

all: box

lint:
	$(PACKER) fmt -check $(PACKER_DIR)
	$(PACKER) validate $(PACKER_DIR)
	$(ANSIBLE_LINT) $(ANSIBLE_DIR)
	$(CODESPELL) .

fmt:
	$(PACKER) fmt $(PACKER_DIR)

clean: clean-box

# build rules: WARP dev box VM
box: box/build/package.box
	
box/build/package.box: $(PACKER_DIR)
	$(PACKER) init $<
	$(PACKER) build --force $<

clean-box: 
	$(RM) $(BOX_DIR)/build
