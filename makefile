#
# WARP
# project makefile
#

# program vars
VAGRANT:=vagrant
PACKER:=packer
RM:=rm -rf

# phony build rules
.PHONY: all box clean
.DEFAULT: all

all: box

clean: clean-box

# build rules: WARP dev box VM
BOX_DIR:=box
box: box/build/package.box
	
box/build/package.box: $(BOX_DIR)/packer
	$(PACKER) fmt $<
	$(PACKER) validate $<
	$(PACKER) build --force $<

clean-box: 
	$(RM) $(BOX_DIR)/build
