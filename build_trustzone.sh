#!/bin/bash

LOCAL_DIR=$(pwd)
MTK_MKIMAGE_TOOL=${LOCAL_DIR}/mkimage
TEE_DRAM_SIZE_CFG=${LOCAL_DIR}/cfg/secure_dram_size.cfg
TEE_DRAM_SIZE=`cat ${TEE_DRAM_SIZE_CFG}`

ATF_COMP_IMAGE_NAME=${LOCAL_DIR}/binary/arm-tf-opteed.img
OPTEE_RAW_IMAGE_NAME=$1
OPTEE_COMP_IMAGE_NAME=$1.img
TRUSTONZE_IMAGE_NAME=trustzone.bin

function build_tee ()
{
    echo "TEE Reserved Memory Size is "${TEE_DRAM_SIZE}
    echo -n "Build secure OS image..."
    ${MTK_MKIMAGE_TOOL} ${OPTEE_RAW_IMAGE_NAME} TEE ${TEE_DRAM_SIZE} 0 ${OPTEE_COMP_IMAGE_NAME}
    echo "Done"
}

function build_trustzone_bin ()
{
    echo -n "Build trustzone binary..."

    cat ${ATF_COMP_IMAGE_NAME} >> ${TRUSTONZE_IMAGE_NAME}    
    cat ${OPTEE_COMP_IMAGE_NAME} >> ${TRUSTONZE_IMAGE_NAME}

    if [ $? -ne 0 ]; then exit 1; fi

    if [ ! -f ${TRUSTONZE_IMAGE_NAME} ] ; then
        echo "[ERROR] TRUSTZONE partition build failed!"
        exit 1
    fi

    echo "Done"
}

rm -f ${TRUSTONZE_IMAGE_NAME}
build_tee
build_trustzone_bin
