#!/bin/bash

LOCAL_DIR=$(pwd)
KERNEL_DIR=$1
RAMDISK_IMG=$2

${LOCAL_DIR}/mkbootimg --kernel ${KERNEL_DIR}/arch/arm64/boot/Image \
    --ramdisk ${RAMDISK_IMG} \
    --second ${KERNEL_DIR}/arch/arm64/boot/dts/mediatek/mt8173-evb.dtb \
    --output boot.img
