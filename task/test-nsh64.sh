#!/usr/bin/env bash
## Automated Testing of Automated Testing of Apache NuttX RTOS for QEMU RISC-V 64-bit Flat Build

set -e  ##  Exit when any command fails
set -x  ##  Echo commands

##  Default Build Prefix
if [ "$BUILD_PREFIX" == '' ]; then
    export BUILD_PREFIX=qemu-riscv-nsh64
fi

##  Default Build Date is today (YYYY-MM-DD)
if [ "$BUILD_DATE" == '' ]; then
    export BUILD_DATE=$(date +'%Y-%m-%d')
fi

rm -rf /tmp/$BUILD_PREFIX
mkdir /tmp/$BUILD_PREFIX
cd /tmp/$BUILD_PREFIX

set +x  ##  Disable echo
date
echo "----- Download the latest NuttX build for $BUILD_DATE"
set -x  ##  Enable echo
wget -q https://github.com/lupyuen/nuttx-riscv64/releases/download/$BUILD_PREFIX-$BUILD_DATE/nuttx.zip
unzip -o nuttx.zip
set +x  ##  Disable echo
date

## Print the Commit Hashes
if [ -f nuttx.hash ]; then
    cat nuttx.hash
fi

##  Write the Release Tag for populating the Release Log later
echo "$BUILD_PREFIX-$BUILD_DATE" >/tmp/release-$BUILD_PREFIX.tag

script=qemu-riscv-nsh64
wget https://raw.githubusercontent.com/lupyuen/nuttx-riscv64/main/$script.exp
chmod +x $script.exp
ls -l
cat nuttx.hash
qemu-system-riscv64 --version
date
./$script.exp
date
