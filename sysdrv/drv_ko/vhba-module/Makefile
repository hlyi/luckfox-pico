VHBA_VERSION := 20250329

ifeq ($(SYSDRV_PARAM), )
	SYSDRV_PARAM:=../../Makefile.param
	include $(SYSDRV_PARAM)
endif

CURRENT_DIR := $(shell pwd)
#INC_FLAGS_VHBA := -I$(CURRENT_DIR)/src/
#SRC_VHBA := $(wildcard $(CURRENT_DIR)/src/*.c)
#OBJ := $(SRC_VHBA:%.c=%.o)
M_OUT_DIR ?= ../out

export OBJ
export INC_FLAGS_VHBA

MODULE_NAME := vhba

ifeq ($(ENABLE_VHBA),y)
	build_target := modules
endif

all: $(build_target)
	@echo "build $(MODULE_NAME) done"

.PHONY: modules clean

$(MODULE_NAME)-objs := vhba.o
obj-m := $(MODULE_NAME).o
#cflags-y := -DVHBA_VERSION=\"$(VHBA_VERSION)\" -Werror
CFLAGS_vhba.o := -DVHBA_VERSION=\"$(VHBA_VERSION)\" -Werror

modules:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNEL_DIR) M=$(shell pwd) $@ -j12
	cp $(shell pwd)/vhba.ko $(M_OUT_DIR)
	@rm -rf *.o *~ .depend .*.cmd  *.mod.c .tmp_versions *.symvers modules.order *.mod
#	@make -C $(shell pwd)/src;
#	@make -C $(shell pwd)/sample;

clean:
	@rm -rf *.o *~ .depend .*.cmd  *.mod.c .tmp_versions *.ko *.symvers modules.order *.mod
	@make -C $(shell pwd)/sample clean
#	@make -C $(shell pwd)/src clean
