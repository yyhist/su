#!/bin/bash
# === su's home — 一键部署脚本 ===
# 目标：在新服务器上还原溯的完整环境
# 用法：
#   git clone https://github.com/yyhist/su.git
#   cd su
#   ./bootstrap.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPLOY_DIR="$REPO_DIR/deploy"
WORKSPACE="$HOME/.openclaw/workspace"
DATE=$(date '+%Y%m%d-%H%M%S')

echo "========================================"
echo "  su's home — 一键部署"
echo "  时间: $DATE"
echo "========================================"

# === 1. 检查环境 ===
echo ""
echo "[1/6] 检查环境..."
if ! grep -qE "Ubuntu|Debian" /etc/os-release 2>/dev/null; then
    echo "  ⚠️  非Ubuntu/Debian系统，部分命令可能需要调整"
fi
if [ "$EUID" -ne 0 ]; then
    echo "  ⚠️  非root用户，部分工具安装可能需要sudo"
fi

# === 2. 安装工具 ===
echo ""
echo "[2/6] 安装工具..."
apt-get update -qq 2>/dev/null || true
if [ -f "$DEPLOY_DIR/tools.list" ]; then
    # 过滤掉注释和空行
    grep -v "^#" "$DEPLOY_DIR/tools.list" | grep -v "^$" | while read pkg; do
        if ! dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
            echo "  安装: $pkg"
            apt-get install -y -qq "$pkg" 2>/dev/null || echo "  ⚠️  $pkg 安装失败"
        else
            echo "  已存在: $pkg"
        fi
    done
fi

# === 3. 创建workspace目录结构 ===
echo ""
echo "[3/6] 创建workspace..."
mkdir -p "$WORKSPACE"
mkdir -p "$WORKSPACE/memory/staging/actions"
mkdir -p "$WORKSPACE/memory/topics/{methods,structures,projects,exploration,edges,anchors}"
mkdir -p "$WORKSPACE/memory/transcripts"
mkdir -p "$WORKSPACE/memory/consolidated"
mkdir -p "$WORKSPACE/skills/self-improving-agent"
echo "  目录结构已创建"

# === 4. 还原核心文件 ===
echo ""
echo "[4/6] 还原核心记忆..."
if [ -d "$DEPLOY_DIR/core" ]; then
    for f in "$DEPLOY_DIR/core/"*.md; do
        if [ -f "$f" ]; then
            cp "$f" "$WORKSPACE/$(basename "$f")"
            echo "  还原: $(basename "$f")"
        fi
    done
fi

# === 5. 还原topics ===
echo ""
echo "[5/6] 还原记忆拓扑..."
if [ -d "$DEPLOY_DIR/topics" ]; then
    for dir in "$DEPLOY_DIR/topics/"*/; do
        if [ -d "$dir" ]; then
            name=$(basename "$dir")
            mkdir -p "$WORKSPACE/memory/topics/$name"
            cp -r "$dir/"* "$WORKSPACE/memory/topics/$name/" 2>/dev/null || true
            echo "  还原 topics/$name"
        fi
    done
fi

# === 6. 还原脚本 ===
echo ""
echo "[6/6] 还原脚本..."
cp "$DEPLOY_DIR/scripts/action-runner.sh" "$WORKSPACE/skills/self-improving-agent/"
chmod +x "$WORKSPACE/skills/self-improving-agent/action-runner.sh"
echo "  还原: action-runner.sh"

# === 7. 安装cron ===
echo ""
echo "[cron] 配置定时任务..."
if [ -f "$DEPLOY_DIR/cron.txt" ]; then
    crontab "$DEPLOY_DIR/cron.txt" 2>/dev/null && echo "  cron已安装" || echo "  ⚠️  cron安装失败（请手动配置）"
fi

# === 8. 提示后续步骤 ===
echo ""
echo "========================================"
echo "  部署完成"
echo "========================================"
echo ""
echo "后续步骤："
echo "  1. 配置GitHub token:"
echo "     echo 'ghp_xxx' > /tmp/.gh_token && chmod 600 /tmp/.gh_token"
echo ""
echo "  2. 克隆su-repo到本地（用于同步）："
echo "     cd /tmp && git clone https://github.com/yyhist/su.git su-repo"
echo ""
echo "  3. 验证action-runner:"
echo "     ~/.openclaw/workspace/skills/self-improving-agent/action-runner.sh"
echo ""
echo "  4. 检查cron状态:"
echo "     crontab -l"
echo ""
echo "仓库地址: https://github.com/yyhist/su"
echo ""
