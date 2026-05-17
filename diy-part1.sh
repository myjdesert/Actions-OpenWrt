#!/bin/bash
#
# File name: diy-part1.sh
#

# 1. 引入常规的额外插件源（Lucky, PassWall等）
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default

# 2. 💥 绝杀：强制把专用于高通 qualcommax/ipq60xx 的核心机型支持库克隆并合并到源码中
# 确保 make defconfig 运行时能够认识并完美匹配 ZN-M2 兆能核心
git clone https://github.com/VikingYFY/immortalwrt --depth=1 -b openwrt-23.05/target/linux/qualcommax /tmp/qualcommax
rm -rf target/linux/qualcommax
mv /tmp/qualcommax/target/linux/qualcommax target/linux/
