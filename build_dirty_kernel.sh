#!/bin/bash
export PATH=/Volumes/NVidia/repo/bin_tmp:$PATH
export CROSS_COMPILE='ccache aarch64-none-elf-'
# Clean first.
#make ARCH=arm64 mrproper
#make ARCH=arm64 tegra_defconfig
#cp ../tegra21x_xusb_firmware ./firmware/
#bash scripts/config --file ./.config --set-str LOCALVERSION "-tegra" --set-str CONFIG_EXTRA_FIRMWARE "tegra21x_xusb_firmware" --set-str CONFIG_EXTRA_FIRMWARE_DIR "firmware"
make ARCH=arm64 -j16

# Build Modules
rm -rf ./modules_testing
rm -rf *.xz
make ARCH=arm64 INSTALL_MOD_PATH=modules_testing modules_install -j12

# Build Headers
rm -rf header_test
make ARCH=arm64 headers_install -j12 INSTALL_HDR_PATH=header_test

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
cp -vr ./header_test constructing/
tar -cvf ./install_image.tar ./constructing
xz -v -9 -T8 ./install_image.tar
