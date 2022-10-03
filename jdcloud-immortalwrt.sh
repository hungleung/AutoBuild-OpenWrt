#!/bin/bash

# For OpenWrt 21.02 or lower version
# You have to manually upgrade Golang toolchain to 1.18 or higher to compile Xray-core.
./openwrt/scripts/feeds update packages
rm -rf openwrt/feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang openwrt/feeds/packages/lang/golang

# change default lan address and hostname
sed -i 's/192.168.1.1/192.168.1.254/g' openwrt/package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/Home/g' openwrt/package/base-files/files/bin/config_generate

# disable wireless components
sed -i 's/\+libiwinfo-lua//' openwrt/feeds/luci/collections/luci/Makefile
sed -i 's/\+libiwinfo//' openwrt/feeds/luci/modules/luci-mod-dashboard/Makefile
sed -i 's/\+libiwinfo-lua//' openwrt/feeds/luci/modules/luci-mod-battstatus/Makefile
sed -i 's/\+rpcd-mod-iwinfo//' openwrt/feeds/luci/modules/luci-mod-battstatus/Makefile
sed -i 's/\+libiwinfo-lua//' openwrt/feeds/luci/modules/luci-mod-network/Makefile
sed -i 's/\+rpcd-mod-iwinfo//' openwrt/feeds/luci/modules/luci-mod-network/Makefile
sed -i 's/\+libiwinfo-lua//' openwrt/feeds/luci/modules/luci-mod-status/Makefile
sed -i 's/\+libiwinfo//' openwrt/feeds/luci/modules/luci-mod-status/Makefile
sed -i -e 's/wpad-basic-openssl//' openwrt/target/linux/ramips/mt7621/target.mk

# disable multi pppoe
# sed -i -e 's/\+libpthread//' package/network/services/ppp/Makefile
sed -i -e 's/\+shellsync//' openwrt/package/network/services/ppp/Makefile
sed -i -e 's/\+kmod-mppe//' openwrt/package/network/services/ppp/Makefile

# change menu title
sed -i 's/"title": "udpxy",/"title": "IPTV",/' openwrt/feeds/luci/applications/luci-app-udpxy/root/usr/share/luci/menu.d/luci-app-udpxy.json

# disable SSRP
# sed -i 's/"ShadowSocksR Plus+"/"SSRP+"/'  openwrt/feeds/luci/applications/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

# change default firmware size and package
sed -i '95,105d' openwrt/target/linux/ramips/dts/mt7621_jdcloud_re-sp-01b.dts
sed -i -e 's/27328k/32448k/' -e 's/kmod-fs-ext4 kmod-mt7603 kmod-mt7615e/lsblk kmod-fs-ext4 e2fsprogs fdisk/' -e 's/kmod-mt7615-firmware kmod-sdhci-mt7620 kmod-usb3/kmod-sdhci-mt7620/' openwrt/target/linux/ramips/image/mt7621.mk

# change default package
sed -i -e 's/kmod-ipt-raw/luci-app-cifs/' -e 's/kmod-nf-nathelper//' -e 's/kmod-nf-nathelper-extra//' -e 's/luci-app-filetransfer/luci-app-udpxy luci-app-vlmcsd luci-app-wireguard luci-app-qbittorrent/' openwrt/include/target.mk
