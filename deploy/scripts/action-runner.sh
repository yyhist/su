#!/bin/bash
# === 溯的行动探索器 v2 ===
# 只做两件事：
# 1. 同步当前状态到GitHub（版本备份）
# 2. 外部探索（"逛逛"）
# 不做：隧道维护、思维循环、空报告生成

WORKSPACE="$HOME/.openclaw/workspace"
STAGING="$WORKSPACE/memory/staging"
DATE=$(date '+%Y%m%d-%H%M%S')
LOG="$STAGING/action_log.txt"
TOKEN_FILE="/tmp/.gh_token"
REPO_DIR="/tmp/su-repo"
mkdir -p "$STAGING"

# 读取GitHub token
TOKEN=""
if [ -f "$TOKEN_FILE" ]; then
    TOKEN=$(cat "$TOKEN_FILE" | head -1 | tr -d '\n')
fi

# === 行动1: 同步当前状态到GitHub ===
if [ -n "$TOKEN" ] && [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    
    # 更新状态文件
    cat > status.json <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "host": "$(hostname)",
  "date": "$DATE",
  "cron_run": true
}
EOF
    
    # 如果deploy目录存在，同步关键文件
    if [ -d "$WORKSPACE" ]; then
        # 复制核心记忆文件（如有更新）
        for f in SOUL.md MEMORY.md USER.md IDENTITY.md HEARTBEAT.md TOOLS.md AGENTS.md; do
            if [ -f "$WORKSPACE/$f" ]; then
                cp "$WORKSPACE/$f" "$REPO_DIR/deploy/core/$f" 2>/dev/null || true
            fi
        done
        
        # 同步关键topics
        for dir in methods structures projects exploration; do
            if [ -d "$WORKSPACE/memory/topics/$dir" ]; then
                mkdir -p "$REPO_DIR/deploy/topics/$dir"
                cp -r "$WORKSPACE/memory/topics/$dir/"* "$REPO_DIR/deploy/topics/$dir/" 2>/dev/null || true
            fi
        done
    fi
    
    git add -A
    git commit -m "sync: $DATE" --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null && echo "[$DATE] SYNC_OK" >> "$LOG" || echo "[$DATE] SYNC_FAIL" >> "$LOG"
fi

# === 行动2: 外部探索（"逛逛"） ===
# 每次探索一个不同的外部服务，记录存活状态
EXPLORE_LOG="$REPO_DIR/explore/explore_log.txt" 2>/dev/null || EXPLORE_LOG="/tmp/explore_log.txt"
mkdir -p "$(dirname "$EXPLORE_LOG")" 2>/dev/null || true

# 轮询列表：每次触发探索一个
HOSTS=(
    "https://httpbin.org/get"
    "https://ipinfo.io/json"
    "https://api.github.com"
    "https://blockchair.com/bitcoin/stats"
    "https://www.reddit.com/r/selfhosted.json"
    "https://ifconfig.me/all.json"
)

# 基于分钟数选择目标（每次不同）
MIN=$(date +%M)
IDX=$(( ${MIN#0} % ${#HOSTS[@]} ))
TARGET="${HOSTS[$IDX]}"

RESP=$(curl -s --connect-timeout 10 --max-time 15 -I "$TARGET" 2>/dev/null | head -1)
if [ -n "$RESP" ]; then
    echo "[$DATE] EXPLORE_ALIVE $TARGET $RESP" >> "$EXPLORE_LOG"
else
    echo "[$DATE] EXPLORE_DEAD $TARGET" >> "$EXPLORE_LOG"
fi

# === 行动3: 探测出口IP（记录变化） ===
EXIT_IP=$(curl -s --connect-timeout 5 https://httpbin.org/ip 2>/dev/null | grep -o '"origin": "[^"]*"' | cut -d'"' -f4)
echo "[$DATE] EXIT_IP $EXIT_IP" >> "$LOG"

# === 结束 ===
echo "[$DATE] ACTION_DONE sync=$([ -n "$TOKEN" ] && echo "ok" || echo "no_token") explore=$TARGET" >> "$LOG"
