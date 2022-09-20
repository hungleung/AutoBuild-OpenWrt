#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: eSirPlayground
# Youtube Channel: https://goo.gl/fvkdwm
#=================================================
#1. Modify default IP
sed -i 's/192.168.1.1/192.168.88.1/g' openwrt/package/base-files/files/bin/config_generate

# 修改主机名为 JDC_Mark1
sed -i 's/OpenWrt/Home/g' openwrt/package/base-files/files/bin/config_generate

sed -i 's/wpad-openssl//' openwrt/target/linux/ramips/mt7621/target.mk

#2. Clear the login password
#sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings

#3. Replace with JerryKuKu’s Argon
#rm openwrt/package/lean/luci-theme-argon -rf

# load dts
# echo '载入 mt7621_jdcloud_re-sp-01b.dts'
curl --retry 3 -s --globoff "https://gist.githubusercontent.com/1-1-2/335dbc8e138f39fb8fe6243d424fe476/raw/[lean's%20lede]mt7621_jdcloud_re-sp-01b.dts" -o openwrt/target/linux/ramips/dts/mt7621_jdcloud_re-sp-01b.dts
# ls -l target/linux/ramips/dts/mt7621_jdcloud_re-sp-01b.dts

# fix2 + fix4.2
# echo '修补 mt7621.mk'
sed -i '/Device\/adslr_g7/i\define Device\/jdcloud_re-sp-01b\n  \$(Device\/dsa-migration)\n  \$(Device\/uimage-lzma-loader)\n  IMAGE_SIZE := 32448k\n  DEVICE_VENDOR := JDCloud\n  DEVICE_MODEL := RE-SP-01B\n  DEVICE_PACKAGES := kmod-usb-storage kmod-usb2 block-mount kmod-fs-ext4 e2fsprogs fdisk kmod-sdhci-mt7620 kmod-usb3\nendef\nTARGET_DEVICES += jdcloud_re-sp-01b\n\n' openwrt/target/linux/ramips/image/mt7621.mk

# fix3 + fix5.2
# echo '修补 02-network'
sed -i -e '/lenovo,newifi-d1|\\/i\        jdcloud,re-sp-01b|\\' -e '/ramips_setup_macs/,/}/{/ampedwireless,ally-00x19k/i\        jdcloud,re-sp-01b)\n\t\tlan_mac=$(mtd_get_mac_ascii u-boot-env mac)\n\t\twan_mac=$(macaddr_add "$lan_mac" 1)\n\t\tlabel_mac=$lan_mac\n\t\t;;
}' openwrt/target/linux/ramips/mt7621/base-files/etc/board.d/02_network

# fix5.1
# echo '修补 system.sh 以正常读写 MAC'
sed -i 's#key"'\''=//p'\''#& \| head -n1#' openwrt/package/base-files/files/lib/functions/system.sh

sed -i -e 's/kmod-nf-nathelper//' -e 's/kmod-nf-nathelper-extra//' -e 's/iptables-mod-extra//' -e 's/kmod-ipt-raw//' -e 's/kmod-tun//' -e 's/ca-certificates//' -e 's/coremark//' -e 's/ddns-scripts_aliyun/luci-app-udpxy/' -e 's/ddns-scripts_dnspod/luci-app-wireguard/' -e 's/luci-app-ddns//' -e 's/luci-app-autoreboot/luci-app-transmission/' -e 's/luci-app-arpbind/luci-app-nfs/' -e 's/luci-app-filetransfer/luci-app-samba4/' -e 's/luci-app-vsftpd/luci-app-minidlna/' -e 's/luci-app-accesscontrol//' -e 's/luci-app-nlbwmon//' -e 's/luci-app-wol//' openwrt/include/target.mk

#=========================================
# Target System
#=========================================
# cat >> .config << EOF
# CONFIG_TARGET_ramips=y
# CONFIG_TARGET_ramips_mt7621=y
# CONFIG_TARGET_ramips_mt7621_DEVICE_jdcloud_re-sp-01b=y
# EOF
