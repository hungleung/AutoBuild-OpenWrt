#!/bin/bash

# For OpenWrt 21.02 or lower version
# You have to manually upgrade Golang toolchain to 1.18 or higher to compile Xray-core.
# ./scripts/feeds update packages
# rm -rf feeds/packages/lang/golang
# svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

# change default lan address and hostname
# verified to be working
sed -i 's/192.168.1.1/192.168.88.1/g' openwrt/package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/Home/g' openwrt/package/base-files/files/bin/config_generate
sed -i 's/\+shellsync//' openwrt/package/network/services/ppp/Makefile
sed -i 's/\+kmod-mppe//' openwrt/package/network/services/ppp/Makefile
sed -i 's/Dynamic DNS/DDNS/g'  openwrt/feeds/luci/applications/luci-app-ddns/luasrc/controller/ddns.lua
sed -i 's/KMS Server/KMS/' openwrt/feeds/luci/applications/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
sed -i 's/ACME certs/ACME/' openwrt/feeds/luci/applications/luci-app-acme/luasrc/controller/acme.lua
sed -i 's/_("udpxy")/_("IPTV")/' openwrt/feeds/luci/applications/luci-app-udpxy/luasrc/controller/udpxy.lua 
#sed -i 's/default y/default n/g'  openwrt/feeds/luci/applications/luci-app-turboacc/Makefile
sed -i '12-15d' openwrt/feeds/luci/applications/luci-app-acme/po/zh-cn/acme.po
sed -i '1-3d' openwrt/feeds/luci/applications/luci-app-vlmcsd/po/zh-cn/vlmcsd.po
sed -i 's/"ShadowSocksR Plus+"/"SSRP+"/'  openwrt/feeds/helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

# disable and remove wireless
#sed -i 's/\+libiwinfo-lua//' openwrt/feeds/luci/collections/luci/Makefile
#sed -i 's/iwinfo//' openwrt/feeds/luci/modules/luci-mod-admin-full/Makefile
#sed -i 's/wpad-openssl//' openwrt/target/linux/ramips/mt7621/target.mk

curl --retry 3 -s --globoff "https://gist.githubusercontent.com/1-1-2/335dbc8e138f39fb8fe6243d424fe476/raw/[lean's%20lede]mt7621_jdcloud_re-sp-01b.dts" -o openwrt/target/linux/ramips/dts/mt7621_jdcloud_re-sp-01b.dts
#disable wireless
#sed -i '/Device\/adslr_g7/i\define Device\/jdcloud_re-sp-01b\n  \$(Device\/dsa-migration)\n  \$(Device\/uimage-lzma-loader)\n  IMAGE_SIZE := 32448k\n  DEVICE_VENDOR := JDCloud\n  DEVICE_MODEL := RE-SP-01B\n  DEVICE_PACKAGES := lsblk block-mount e2fsprogs fdisk kmod-fs-ext4 kmod-sdhci-mt7620 kmod-usb3\nendef\nTARGET_DEVICES += jdcloud_re-sp-01b\n\n' openwrt/target/linux/ramips/image/mt7621.mk
sed -i '/Device\/adslr_g7/i\define Device\/jdcloud_re-sp-01b\n  \$(Device\/dsa-migration)\n  \$(Device\/uimage-lzma-loader)\n  IMAGE_SIZE := 32448k\n  DEVICE_VENDOR := JDCloud\n  DEVICE_MODEL := RE-SP-01B\n  DEVICE_PACKAGES := lsblk block-mount e2fsprogs fdisk kmod-fs-ext4 kmod-sdhci-mt7620 kmod-usb3 kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware wpad-openssl\nendef\nTARGET_DEVICES += jdcloud_re-sp-01b\n\n' openwrt/target/linux/ramips/image/mt7621.mk
sed -i -e '/lenovo,newifi-d1|\\/i\        jdcloud,re-sp-01b|\\' -e '/ramips_setup_macs/,/}/{/ampedwireless,ally-00x19k/i\        jdcloud,re-sp-01b)\n\t\tlan_mac=$(mtd_get_mac_ascii u-boot-env mac)\n\t\twan_mac=$(macaddr_add "$lan_mac" 1)\n\t\tlabel_mac=$lan_mac\n\t\t;;
    }' openwrt/target/linux/ramips/mt7621/base-files/etc/board.d/02_network
sed -i 's#key"'\''=//p'\''#& \| head -n1#' openwrt/package/base-files/files/lib/functions/system.sh

# change default package
sed -i -e 's/ddns-scripts_aliyun ddns-scripts_dnspod/ddns-scripts_cloudflare.com-v4/' -e 's/luci-app-autoreboot/luci-app-udpxy/' -e 's/luci-app-arpbind luci-app-filetransfer luci-app-vsftpd/luci-app-acme acme-dnsapi acme-deploy acme-notify luci-ssl-openssl/' -e 's/luci-app-accesscontrol luci-app-nlbwmon luci-app-turboacc luci-app-wol /luci-app-turboacc luci-app-wireguard /'  openwrt/include/target.mk
# add flexget dependency
#sed -i -e 's/ddns-scripts_aliyun ddns-scripts_dnspod/ddns-scripts_cloudflare.com-v4 python python-sqlite3 pyyaml python-sqlite python-expat python-openssl python-bzip2 distribute/' -e 's/luci-app-autoreboot/luci-app-udpxy/' -e 's/luci-app-arpbind luci-app-filetransfer luci-app-vsftpd/luci-app-acme acme-dnsapi acme-deploy acme-notify luci-ssl-openssl/' -e 's/luci-app-accesscontrol luci-app-nlbwmon luci-app-turboacc luci-app-wol /luci-app-turboacc luci-app-wireguard /'  openwrt/include/target.mk
