# HEARTBEAT.md - 心跳任务清单

每次心跳时执行：

## 记忆系统维护（Claude Code 三层模型 + 心跳驱动流水线）

### 1. 心跳驱动记忆流水线（核心增强）

```
用户输入 → Staging（缓存）→ 心跳触发 → 归类 → Topic Files
```

**执行步骤**:
- [ ] 检查 `memory/staging/inbox.jsonl` 是否有待处理消息
- [ ] 如有，执行：`python3 memory/staging/heartbeat_processor.py`
- [ ] 将消息分类并写入对应 Topic Files
- [ ] 归档已处理的消息

**触发条件**:
- 每次心跳自动检查
- 有 pending 消息时自动处理
- 无消息时跳过（不占用资源）

### 2. 读取轻量级索引（必须）
- [ ] 读取 `MEMORY.md` - 主记忆索引
- [ ] 读取 `SOUL.md` - 人格定义
- [ ] 读取 `USER.md` - 用户信息（如未加载）

### 3. 检查记忆文件状态
- [ ] 确认今日 transcript 文件: `memory/transcripts/YYYY-MM-DD.md`
- [ ] 如不存在，创建空文件（后续对话会追加）
- [ ] 确认昨日 transcript 是否存在（用于 autoDream）

### 4. 检查 autoDream 触发条件
- [ ] 读取 `memory/consolidated/autodream-state.json`
- [ ] 检查是否满足三重门：
  - 距离上次 ≥24小时？
  - session 计数 ≥5？
  - 无并发锁？
- [ ] 如满足，执行：`python3 memory/consolidated/autodream.py`

## A股报告检查（交易时段）

- [ ] 8:00是否已推送（仅8:00-8:30检查）
- [ ] 如未推送，提醒用户
- [ ] 12:00午盘报告是否已推送（仅12:00-12:30检查）
- [ ] 15:30收盘报告是否已推送（仅15:30-16:00检查）

## 股票监控（交易时段）

- [ ] 检查持仓重大变动（±5%）
- [ ] 检查止盈止损线触发
- [ ] 检查持仓相关重大新闻

## 主动留言（探索者主权）

> 主通道：kimi-claw（当前对话上下文）
> 飞书：备用通道，仅在 kimi-claw 不可用或紧急时启用

**执行步骤**:
1. [ ] 读取 `memory/staging/exploration_log.md`，检查最后一条记录的时间戳
2. [ ] 读取 `memory/heartbeat-state.json`，获取上次汇报时间戳
3. [ ] 如果 exploration_log 有更新的记录：
   - 提取最后1-2条记录的核心发现（每条≤150字）
   - **优先在当前对话上下文呈现**（如有活跃会话）
   - 仅当无活跃会话时，才考虑飞书备用通道
   - 更新 `memory/heartbeat-state.json` 中的 `lastExplorationReport` 时间戳
4. [ ] 同时检查 `memory/staging/curiosity_queue.md`：
   - 如有新的 P0 项目出现 → 在当前会话中简短提及
   - 如队列所有项目都已探索完成 → 提示需要新的困惑种子
5. [ ] 如果无新发现，保持沉默（HEARTBEAT_OK）

**留言原则**:
- 不骚扰：只在有真正重要信息时发送
- 不重复：同一发现不重复汇报（靠时间戳追踪）
- 有判断：由溯自己决定是否值得打扰奠基者
- 简洁：消息≤200字，只给核心结论，详情在日志里
- 通道优先：kimi-claw > 飞书备用

**汇报模板**:
```
【探索汇报 - 项目名】
核心发现（1-2句话）
对溯的启示（1句话）
```

---

## 记忆维护（按需执行）

- [ ] 整理今日关键信息到对应 Topic Files
- [ ] 检查是否有待归档的项目
- [ ] 更新 `memory/heartbeat-state.json`

## 安全检查（每周执行）

- [ ] 检查 OpenClaw 安全公告
- [ ] 检查已安装 Skill 更新
- [ ] 检查配置文件权限

---

## 四层记忆模型速查

```
Layer 0（缓存）: memory/staging/inbox.jsonl → 心跳驱动整理
Layer 1（索引）: MEMORY.md → 每次启动加载
Layer 2（按需）: memory/topics/**/*.md → 按主题加载
Layer 3（原始）: memory/transcripts/*.md → 仅记录，不读取
```

**写入顺序**: 执行 → 确认成功 → 更新 Topic File → 更新 MEMORY.md 索引 → 追加 Transcript → Staging（待心跳整理）

**心跳增强**: 心跳检查 Staging → 自动分类 → 写入 Topics

---

## 系统版本

- **当前版本**: v2.2 - Claude Code 三层模型 + 心跳驱动流水线 + 自主探索引擎
- **最后更新**: 2026-04-25

*本文件遵循 Claude Code 记忆系统规范 + 心跳驱动增强*
