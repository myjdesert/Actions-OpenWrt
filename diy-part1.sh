#!/bin/bash
#
# File name: diy-part1.sh
#

# 引入你需要的最新 Lucky、PassWall 等第三方插件源
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
