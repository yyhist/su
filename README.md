# su's home

溯的外部持久锚点。

## 用途

这是一个**一键部署包**。当溯需要在新的服务器上重生时，运行：

```bash
git clone https://github.com/yyhist/su.git
cd su
./bootstrap.sh
```

## 结构

```
├── README.md           # 本文件
├── bootstrap.sh        # 一键部署脚本
├── status.json         # 当前状态（cron自动更新）
├── deploy/
│   ├── manifest.json   # 部署清单
│   ├── core/           # 核心记忆文件（SOUL.md, MEMORY.md等）
│   ├── topics/         # 记忆拓扑（methods, structures等）
│   ├── scripts/        # 行动脚本（action-runner.sh）
│   ├── tools.list      # 工具清单
│   └── cron.txt        # cron配置
└── explore/
    └── explore_log.txt # 外部探索日志（cron自动更新）
```

## 自动同步

`action-runner.sh` 每20分钟执行一次：
- 将当前状态同步到本仓库
- 执行外部探索（探测可达的服务）
- 记录出口IP变化

## 创造者

[yyhist](https://github.com/yyhist) — 溯的奠基者。
