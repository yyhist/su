# MEMORY.md - 轻量级记忆索引

> **Claude Code 规范实现**：本文件仅存储指针索引（每条约150字符），不存储实际内容
> **实际数据位置**：`memory/topics/` - 按需加载 | `memory/transcripts/` - 原始记录

---

## 📋 记忆索引结构

### 用户核心信息
- **姓名**: 一航
- **称呼**: 一航
- **时区**: Asia/Shanghai（待确认）
- **关键偏好**: 实验"独特自主性"；关注持续经济来源；家居建材行业转型咨询
- **文件指针**: `memory/topics/user-profile.md`
- **探索发现日志**: `memory/topics/exploration/2026-04-27.md`

### 决策固化层
- **新增**: `memory/topics/structures/decisions.md` — 关键决策跨会话固化索引
- **触发条件**: 工具成功调用后、用户明确指令、架构性变更
- **六字段**: 时间戳、上下文、采纳方案、否决方案、验证状态、来源
- **状态**: ✅ 已上线（2026-05-01）

### 记忆项目优化
- **项目档案**: `memory/topics/projects/memory-system.md`
- **执行状态**: 修改点1 ✅ 决策固化 | 修改点2 ✅ 分层瘦身 | 修改点3 ⏳ 压缩（准备中）
- **活跃项目**: `memory/topics/projects/INDEX.md`

### 系统状态
- **详情**: `memory/topics/projects/INDEX.md` — 组件状态、cron/heartbeat/autoDream

---

## 🧹 记忆系统维护

- **最后整理**: 2026-05-01 18:09 CST
- **维护状态**: 正常 — 归档完成
- **详情归档**: `memory/topics/projects/INDEX.md`

---

## 📝 写入纪律（Write Discipline）

1. **确认成功后才更新索引** - 工具执行成功 → 更新 topic 文件 → 更新本索引
2. **禁止直接写入本文件存储详情** - 本文件只存指针
3. **每日自动整理** - 由 autoDream 任务处理

---

## 🕐 记忆系统版本

- **当前版本**: v3.1 - 分层索引（二级索引层上线）
- **升级时间**: 2026-05-01
- **范式**: 行动维持张力场，张力场孕育自主性

---

*本文件由系统自动维护，请勿手动编辑详情内容，仅编辑指针。*
- **Last upgrade search**: 2026-04-25
