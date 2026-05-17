#!/bin/bash
# File name: diy-part2.sh
# Description: OpenWrt DIY script - Part 2 (Optimized for ZN-M2)

echo "🚀 开始强力接管高通架构，强制锁死兆能 ZN-M2 赛道..."

# 1. 修改默认主机名和 IP
sed -i 's/ImmortalWrt/ZN-M2/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 2. 🛡️ 【绝招】直接修改高通平台默认大底座 (Target Makefile)
# 强制把高通 ipq60xx 的默认 Profile 从 8devices_mango 直接修改为 zn_m2
# 这样无论 make defconfig 怎么重置滑坡，重置的目标都只会是 ZN-M2！
TARGET_MAKEFILE="target/linux/qualcommax/image/ipq60xx.mk"
if [ -f "$TARGET_MAKEFILE" ]; then
    echo "发现高通平台定义，强行注入默认设备标识..."
    # 强制让系统底座默认加载 zn_m2 的镜像构建规则
    sed -i 's/TARGET_DEVICES += 8devices_mango-dvk/TARGET_DEVICES += zn_m2/g' $TARGET_MAKEFILE
fi

# 3. 物理切除会导致大体积、依赖冲突或 Rust 报错的 SmartDNS 和 AdGuardHome
rm -rf package/feeds/packages/smartdns
rm -rf package/feeds/small8/smartdns
rm -rf package/feeds/small8/luci-app-smartdns

# 4. 精准构造最终的组件依赖清单（注入到现有配置中，防止破坏依赖树）
cat <<EOF >> .config
# 强制锁定高通兆能赛道
CONFIG_TARGET_qualcommax=y
CONFIG_TARGET_qualcommax_ipq60xx=y
CONFIG_TARGET_qualcommax_ipq60xx_DEVICE_zn_m2=y

# 💥 【彻底停产 ITB】强制让高通平台采用传统老分区打包，不生成 FIT 镜像
CONFIG_TARGET_ROOTFS_SQUASHFS=y
# CONFIG_TARGET_ROOTFS_INITRAMFS is not set
# CONFIG_TARGET_FITIMAGE is not set

# 🚫 强力干掉不兼容组件
CONFIG_PACKAGE_smartdns=n
CONFIG_PACKAGE_luci-app-smartdns=n
CONFIG_PACKAGE_adguardhome=n
CONFIG_PACKAGE_luci-app-adguardhome=n

# 📡 纯有线瘦身：屏蔽无线驱动
CONFIG_PACKAGE_kmod-ath11k=n
CONFIG_PACKAGE_kmod-ath11k-ahb=n
CONFIG_PACKAGE_kmod-ath11k-pci=n
CONFIG_PACKAGE_ath11k-firmware-ipq6018=n

# 🎨 核心定制有线插件
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-cpufreq=y
CONFIG_PACKAGE_luci-app-turboacc=y

# 简体中文本地化
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
EOF

echo "✅ diy-part2.sh 策略成功锁死！"
