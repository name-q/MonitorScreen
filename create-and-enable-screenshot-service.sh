#!/bin/bash

# 获取当前脚本所在目录
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# 打包后的可执行文件名
EXECUTABLE="monitor-screen"

# 目标目录
TARGET_DIR="/opt"

# plist 文件名
PLIST_FILE="com.qy.screenshot.plist"

# 检查是否具有管理员权限
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本。"
  exit 1
fi

# 创建目标目录（如果不存在）
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
fi

# 复制可执行文件到目标目录
cp "$SCRIPT_DIR/$EXECUTABLE" "$TARGET_DIR"

# 设置可执行权限
chmod +x "$TARGET_DIR/$EXECUTABLE"

# 复制 plist 文件到 ~/Library/LaunchAgents 目录
cp "$SCRIPT_DIR/$PLIST_FILE" "$HOME/Library/LaunchAgents/"

# 加载 plist 文件
launchctl load "$HOME/Library/LaunchAgents/$PLIST_FILE"

echo "服务已成功安装并启用。"
