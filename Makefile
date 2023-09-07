obj-m += test_smc.o
PWD := $(shell pwd)
OUTPUT := $(obj-m) $(obj-m:.o=.ko) $(obj-m:.o=.mod.o) $(obj-m:.o=.mod.c) modules.order Module.symvers .hwcourse.*.cmd .tmp_versions

modules:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules

clean:
	rm -rf $(OUTPUT)

