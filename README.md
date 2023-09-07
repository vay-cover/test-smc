# test_smc

#### 介绍
test for smc

#### 使用说明

1.  编译test_smc.ko
    - make KERNEL_DIR=/lib/modules/[kernel_dir]/build
2.  插入test_smc.ko
    - insmod test_smc.ko
3.  执行脚本
    - bash atf_test.sh stress [n] [path/to/smc_invoke]
