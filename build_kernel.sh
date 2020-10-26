#!/bin/bash
export PATH=/Volumes/NVidia/repo/bin_tmp:$PATH
export CROSS_COMPILE='ccache /Volumes/NVidia/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-'
# Clean first.
make ARCH=arm64 mrproper
make ARCH=arm64 tegra_defconfig
cp ../tegra21x_xusb_firmware ./firmware/
bash scripts/config --file ./.config --set-str LOCALVERSION "-tegra" --set-str CONFIG_EXTRA_FIRMWARE "tegra21x_xusb_firmware" --set-str CONFIG_EXTRA_FIRMWARE_DIR "firmware"
make ARCH=arm64 -j12

# Build Modules
rm -rf ./modules_testing
make ARCH=arm64 INSTALL_MOD_PATH=modules_testing modules_install -j12

# Create Installable tar
rm -f install_image.tar
rm -rf constructing
mkdir constructing
cp ./install_kernel.sh constructing/
cp ./8192cu constructing/8192cu.ko
cp arch/arm64/boot/Image constructing/
mkdir constructing/dtb
cp arch/arm64/boot/dts/* constructing/dtb/
cp -vr ./modules_testing constructing/
tar -cvf ./install_image.tar ./constructing
xz -v -9 -T8 ./install_image.tar
