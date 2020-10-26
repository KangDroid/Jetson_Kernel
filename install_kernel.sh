#!/bin/bash

export KERNVER=4.9.140-tegra+

sudo cp ./Image /boot/
sudo cp ./dtb/* /boot/

sudo cp -vr modules_testing/lib/modules/$KERNVER /lib/modules/

sudo install -p -m 644 8192cu.ko /lib/modules/$KERNVER
sudo /sbin/depmod -a $KERNVER