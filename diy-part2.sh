#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

echo "🚀 开始执行 24.10 定制流：强行注入高通 ZN-M2 核心架构与专属插件..."

# 1. 强行清空并重写当前的 .config 基础底座
# 确保在 24.10 底层下完美识别高通 qualcommax 赛道及兆能 M2 机型
cat <<EOF > .config
CONFIG_TARGET_qualcommax=y
CONFIG_TARGET_qualcommax_ipq60xx=y
CONFIG_TARGET_qualcommax_ipq60xx_DEVICE_zn_m2=y

# 核心视觉外观（选用 24.10 极其稳定的新版 Argon 主题）
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y

# 核心网络加速组件
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_BBR-CC=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_PDNSD=y

# 核心定制功能插件注入（完美对齐 24.10 依赖体系）
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-cpufreq=y

# 全局环境补全与本地化（强制简体中文）
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
EOF

# 2. 核心轻量化瘦身：剥离无用依赖（实现纯有线高通满血轻量固件）
# 注释掉 24.10 下可能冲突的旧版无线宏，让核心只专注于跑满有线千兆
sed -i '/CONFIG_PACKAGE_kmod-ath11k/d' .config
sed -i '/CONFIG_PACKAGE_ath11k-firmware/d' .config

# 3. 自定义个性化微调
# 修改默认管理 IP 为 192.168.1.1（如果需要修改，可以把下面这行的 # 删掉并自行修改 IP）
# sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名为 ZN-M2
sed -i 's/ImmortalWrt/ZN-M2/g' package/base-files/files/bin/config_generate

echo "✨ 24.10 定制流注入完成！核心安检准备就绪！"
