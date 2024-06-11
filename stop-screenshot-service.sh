#!/bin/bash

# 检查是否具有管理员权限
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本。"
  exit 1
fi

# plist 文件名
PLIST_FILE="com.qy.screenshot.plist"
USER_HOME=$(eval echo ~${SUDO_USER})
PLIST_PATH="$USER_HOME/Library/LaunchAgents/$PLIST_FILE"

# 检查文件是否存在
if [ ! -f "$PLIST_PATH" ]; then
  echo "找不到 plist 文件：$PLIST_PATH"
  exit 1
fi

# 获取当前用户ID
USER_ID=$(id -u $SUDO_USER)

# 停止并卸载服务
launchctl bootout gui/$USER_ID "$PLIST_PATH"

if [ $? -eq 0 ]; then
  echo "服务已成功停止并卸载。"
else
  echo "无法停止并卸载服务，请检查错误信息。"
fi
