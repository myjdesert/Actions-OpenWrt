#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
#

# 1. 终极防御：在虚拟机根目录下提前创建一个假的 swapfile 并剥夺其所有权限，彻底废掉源码脚本对它的作死操作
sudo touch /swapfile
sudo chmod 000 /swapfile

# 2. 引入你需要的最新 Lucky、PassWall 插件源
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
