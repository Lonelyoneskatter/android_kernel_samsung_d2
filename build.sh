#!/bin/bash

# Colorize build warnings, errors, and scripted prints
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
blu=$(tput setaf 4) # blue
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
txtrst=$(tput sgr0) # Reset

export KERNEL_DIR=$(pwd)
export TOOLCHAIN_DIR=$HOME/toolchains/uber/
export TOOLCHAIN_VERSION=arm-eabi-6.x
export BUILD_THREADS=1
export KERNEL_DEFCONFIG=skatter_d2_defconfig

# Toolchains

#UBER
BCC=$TOOLCHAIN_DIR/$TOOLCHAIN_VERSION/bin/arm-eabi-

# Cleanup old files from build environment

CLEANUP()
{
if [ -f arch/arm/boot/zImage ]; then
   rm arch/arm/boot/zImage;
fi;
	make clean
	make mrproper
	make distclean
	ccache -c
}

# Set build environment variables & compile
BUILD_KERNEL()
{
	export ARCH=arm
	export SUBARCH=arm
	export CCACHE=CCACHE
	export USE_CCACHE=1
	export USE_SEC_FIPS_MODE=true
	export KCONFIG_NOTIMESTAMP=true
	export CROSS_COMPILE=$BCC
	export ENABLE_GRAPHITE=true
	make $KERNEL_DEFCONFIG SELINUX_DEFCONFIG=selinux_defconfig
	make -j$BUILD_THREADS
}

# Check if Image was compiled successful
IMAGE_CHECK()
{
if [ -f "arch/arm/boot/zImage" ]; then
	echo "Done, Image compilation was successful!"
echo "${bldred}         _______        ${txtrst}"
echo "${bldred}        /******/|       ${txtrst}"
echo "${bldred}        #######*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}   _____#     #*|_____  ${txtrst}"
echo "${bldred}  /*****#     #*/****/| ${txtrst}"
echo "${bldred}  #######     #######*| ${txtrst}"
echo "${bldred}  #                 #*| ${txtrst}"
echo "${bldred}  #                 #*| ${txtrst}"
echo "${bldred}  #######     #######/  ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*|       ${txtrst}"
echo "${bldred}        #     #*/       ${txtrst}"
echo "${bldred}        #######/        ${txtrst}"
else
	echo "............................................."
	echo "Image compilation Failed!"
	echo "Please check build.log!"
	echo "............................................."
	echo " "
fi
}

# Create Log File of Build

rm -rf ./build.log
(
	START_TIME=`date +%s`
	CLEANUP
	BUILD_KERNEL
	IMAGE_CHECK
	END_TIME=`date +%s`
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time is $ELAPSED_TIME seconds"
	echo " "
) 2>&1	 | tee -a ./build.log

exit 1
