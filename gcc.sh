#!/usr/bin/env bash
# Copyright (C) 2018 Abubakar Yagob (blacksuan19)
# Copyright (C) 2018 Rama Bondan Prakoso (rama982)
# Copyright (C) 2019 Dhimas Bagus Prayoga (Kry9toN)
# Copyright (C) 2020 William Zambrano (willizambrano)
# SPDX-License-Identifier: GPL-3.0-or-later

# Color
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Main Environment
KERNEL_DIR=/home/william/Evolution-vince
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=/home/william/Kernel_vince/AnyKernel-vince
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs
CONFIG=vince_defconfig
CORES=$(grep -c ^processor /proc/cpuinfo)
THREAD="-j$CORES"
CROSS_COMPILE="ccache"
CROSS_COMPILE=/home/william/Kernel_vince/aarch64-elf-gcc-9.x/bin/aarch64-elf-
CROSS_COMPILE_ARM32=/home/william/Kernel_vince/arm-eabi-gcc-9.x/bin/arm-eabi-

# Export
export KBUILD_BUILD_USER="willizambrano"  
export KBUILD_BUILD_HOST="william-pc"
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=/home/william/Kernel_vince/aarch64-elf-gcc-9.x/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=/home/william/Kernel_vince/arm-eabi-gcc-9.x/bin/arm-eabi-


# Is this logo
echo -e "-----------------------------------------------------------------------";
echo -e "-----------------------------------------------------------------------\n";
echo -e "   _____   ______   _____    ____    ______   _____    _    _    _____ "; 
echo -e "  / ____| |  ____| |  __ \  |  _ \  |  ____| |  __ \  | |  | |  / ____|";
echo -e " | |      | |__    | |__) | | |_) | | |__    | |__) | | |  | | | (___  ";
echo -e " | |      |  __|   |  _  /  |  _ <  |  __|   |  _  /  | |  | |  \___ \ ";
echo -e " | |____  | |____  | | \ \  | |_) | | |____  | | \ \  | |__| |  ____) |";
echo -e "  \_____| |______| |_|  \_\ |____/  |______| |_|  \_\  \____/  |_____/ ";
echo -e "                                                                     \n"; 
echo -e "-----------------------------------------------------------------------";
echo -e "-----------------------------------------------------------------------";

                                                   
# Main script
while true; do
	echo -e "\n[1] Build AOSP Kernel"
	echo -e "[2] Regenerate defconfig"
	echo -e "[3] Source cleanup"
	echo -e "[4] Create flashable zip"
	echo -e "[5] Quit"
	echo -ne "\n(i) Please enter a choice[1-5]: "
	
	read choice
	
	if [ "$choice" == "1" ]; then
		echo -e ""
		make  O=out $CONFIG $THREAD &>/dev/null
		make  O=out $THREAD & pid=$!   
	
BUILD_START=$(date +"%s")
DATE=`date`

		echo -e "\n#######################################################################"

		echo -e "$cyan(i) Build started at $DATE using $CORES thread$nocol"

		spin[0]="-"
		spin[1]="\\"
		spin[2]="|"
		spin[3]="/"
		echo -ne "\n[Please wait...] ${spin[0]}"
		while kill -0 $pid &>/dev/null
		do
			for i in "${spin[@]}"
			do
				echo -ne "\b$i"
				sleep 0.1
			done
		done
	
		if ! [ -a $KERN_IMG ]; then
			echo -e "\n(!) Kernel compilation failed, See buildlog to fix errors"
			echo -e "#######################################################################"
			exit 1
		fi
	
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

		echo -e "$yellow\n(i) Image-dtb compiled successfully."

		echo -e "#######################################################################"

		echo -e "$red(i) Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds$nocol"

		echo -e "#######################################################################"
	fi
	
	if [ "$choice" == "2" ]; then
		echo -e "\n#######################################################################"

		make O=out  $CONFIG savedefconfig &>/dev/null
		cp out/defconfig arch/arm64/configs/$CONFIG &>/dev/null

		echo -e "(i) Defconfig generated."

		echo -e "#######################################################################"
	fi
	
	if [ "$choice" == "3" ]; then
		echo -e "\n#######################################################################"

		make O=out clean &>/dev/null
		make mrproper &>/dev/null
		rm -rf out/*

		echo -e "$yellow(i) Kernel source cleaned up $nocol"

		echo -e "#######################################################################"
	fi
	
	if [ "$choice" == "4" ]; then
		echo -e "\n#######################################################################"

		cd $ZIP_DIR
		make clean &>/dev/null
		cp $KERN_IMG $ZIP_DIR/zImage
		make normal &>/dev/null
		cd ..

		echo -e "(i) Flashable zip generated under $ZIP_DIR."

		echo -e "#######################################################################"
	fi
	
	if [ "$choice" == "5" ]; then
		exit 
	fi

done
echo -e "$nc"

