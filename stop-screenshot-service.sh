#!/bin/bash

# 检查是否具有管理员权限
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本。"
  exit 1
fi

# plist 文件名
PLIST_FILE="com.qy.screenshot.plist"

# 停止并卸载服务
launchctl unload "$HOME/Library/LaunchAgents/$PLIST_FILE"

echo "服务已成功停止并卸载。"
