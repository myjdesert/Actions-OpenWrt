#!/bin/bash

# 1. 强行重写清空 openwrt 根目录下的 .config，杜绝任何残余和乱码
cat <<EOF > .config
CONFIG_TARGET_qualcommax=y
CONFIG_TARGET_qualcommax_ipq60xx=y
CONFIG_TARGET_qualcommax_ipq60xx_DEVICE_zn_m2=y

# 视觉外观
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y

# 核心网络加速与高通 NSS 硬件加速
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_BBR-CC=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_PDNSD=y
CONFIG_PACKAGE_kmod-qca-nss-drv=y
CONFIG_PACKAGE_kmod-qca-nss-ecm=y

# 核心定制功能插件
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_easytier=y
CONFIG_PACKAGE_luci-app-easytier=y
CONFIG_PACKAGE_rtp2http=y
CONFIG_PACKAGE_luci-app-rtp2http=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-cpufreq=y
CONFIG_PACKAGE_luci-app-xap=y

# 基础语言包（简体中文）
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
EOF

# 2. 强制转换成纯正的 Linux 换行符，防止系统读取出错退回 x86
sed -i 's/\r$//' .config

echo "🚀 高通 ZN-M2 核心架构与专属插件已强行灌注成功！"
