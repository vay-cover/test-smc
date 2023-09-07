#include <linux/module.h>
#include <linux/sysfs.h>
#include <linux/kobject.h>

u64 test_smc_invoke(u64 smc_cmd_id, u64 arg0, u64 arg1, u64 arg2, u64 arg3)
{
    u64 ret = 0;
    asm volatile("mov x0, %0" : : "r"(smc_cmd_id));
    asm volatile("mov x1, %0" : : "r"(arg0));
    asm volatile("mov x2, %0" : : "r"(arg1));
    asm volatile("mov x3, %0" : : "r"(arg2));
    asm volatile("mov x4, %0" : : "r"(arg3));

    asm volatile("smc #0");
    asm volatile("mov x0, %0"  : "=r"(ret));
    return ret;
}

ssize_t test_smc_sysfs_write(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t cnt)
{
    char *next = NULL;
    u64 args[4];
        u32 i, smc_cmd_id = simple_strtoul(buf, &next, 0);

        for (i = 0; i < 4; i++)
                args[i] = simple_strtoul(next+1, &next, 0);

    printk("test smc invoke: cmd 0x%x, args 0x%llx 0x%llx 0x%llx 0x%llx.", smc_cmd_id, args[0], args[1], args[2], args[3]);
    printk("test smc invoke: result 0x%llx.\n", test_smc_invoke(smc_cmd_id, args[0], args[1], args[2], args[3]));
    return cnt;
}

static struct kobj_attribute g_test_smc_attr = __ATTR(invoke, S_IWUSR, NULL, test_smc_sysfs_write);
static struct attribute *g_test_smc_attrs[] = {&g_test_smc_attr.attr, NULL};
static struct attribute_group g_test_smc_attr_group = { .attrs = g_test_smc_attrs, };

struct kobject *g_test_smc_kobj = NULL;
void test_smc_sysfs_init(void)
{
    int ret;
    g_test_smc_kobj = kobject_create_and_add("smc_test", kernel_kobj);
    if (g_test_smc_kobj == NULL) {
        pr_err("create and add smc dfx failed\n");
        return;
    }

    ret = sysfs_create_group(g_test_smc_kobj, &g_test_smc_attr_group);
    if (ret != 0) {
        kobject_del(g_test_smc_kobj);
        kobject_put(g_test_smc_kobj);
        pr_err("create smc group attrs failed(%d)\n", ret);
    }
    return;
}

void test_smc_sysfs_exit(void)
{
    sysfs_remove_group(g_test_smc_kobj, &g_test_smc_attr_group);
    kobject_del(g_test_smc_kobj);
    kobject_put(g_test_smc_kobj);
    g_test_smc_kobj = NULL;
}

int __init test_smc_module_init(void)
{
    test_smc_sysfs_init();
    return 0;
}

void __exit test_smc_module_exit(void)
{
    test_smc_sysfs_exit();
}

module_init(test_smc_module_init);
module_exit(test_smc_module_exit);
MODULE_LICENSE("GPL");