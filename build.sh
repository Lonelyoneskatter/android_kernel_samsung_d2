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

# Toolchain Directory / Defconfig
export TOOLCHAIN_DIR=$HOME/toolchains/uber
BCC=$TOOLCHAIN_DIR/arm-eabi-6.x-/bin/arm-eabi-
export BUILD_THREADS=15
export KERNEL_DEFCONFIG=skatter_d2_defconfig

CLEAN_DIR()
{
 make clean
 make mrproper
 make distclean
 ccache -c

 if [ -f arch/arm/boot/zImage ]; then
    echo "Removing old kernel zImage"
    rm arch/arm/boot/zImage
    rm $HOME/Skatter_Kernel/zImage
 else
    echo "No Need to clean it."
 fi;
}

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
make $KERNEL_DEFCONFIG VARIANT_DEFCONFIG=skatter_d2_defconfig SELINUX_DEFCONFIG=selinux_defconfig
make -j$BUILD_THREADS
}

MOVE_IMAGE()
{
if [ -f arch/arm/boot/zImage ]; then
   if [ -d $HOME/Skatter_Kernel/ ];then
      cp arch/arm/boot/zImage $HOME/Skatter_Kernel;
   else
      mkdir $HOME/Skatter_Kernel/
      cp arch/arm/boot/zImage $HOME/Skatter_Kernel;
   fi;
fi;
}

clear


(
	START_TIME=`date +%s`
	CLEAN_DIR
	BUILD_KERNEL
	MOVE_IMAGE
	END_TIME=`date +%s`
        clear
        if [ -f arch/arm/boot/zImage ]; then
        echo "Kernel was finished at $( date +"%m-%d-%Y %H:%M:%S" )"
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Took $ELAPSED_TIME seconds to compile"
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
        echo "Did not finish compiling..."
        echo "Kernel stopped at $( date +"%m-%d-%Y %H:%M:%S" )"
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Took $ELAPSED_TIME seconds to not compile"
        fi
)

exit 1
