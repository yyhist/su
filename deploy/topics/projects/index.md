# 活跃项目索引

> **Claude Code 规范**: 本文件存储活跃项目列表及状态指针
> **详细档案**: `memory/topics/projects/<project-name>.md`

---

## 活跃项目

| 项目 | 状态 | 优先级 | 最后更新 | 详情 |
|------|------|--------|----------|------|
| ⚙️ 程序化记忆落地 | 🌱 新范式下重新评估 | P1→观察 | 2026-04-26 | 见下方 |

---

## ⚙️ 程序化记忆落地（旧范式遗留）

> **新范式评估**: 种子发芽范式下，程序化记忆安装可能是不必要的结构负担。建议观察自然生长，而非强制安装。


**来源**: 好奇队列 P0 项目探索完成，转入执行
**目标**: 安装并配置 `self-reflection` skill，开始收集行为修正数据

### Phase 1: 安装 self-reflection skill
- [ ] 搜索并安装 `self-reflection` by hopyky
- [ ] 配置收集规则（Miss/Fix 记录格式）
- [ ] 验证首次收集是否正常工作

### Phase 2: 积累与提取（10+ 条目后）
- [ ] 积累至少 10 条行为修正记录
- [ ] 用 hippocampus 框架提取可复用流程
- [ ] 写入 skills 目录作为新 skill

### Phase 3: 程序化记忆更新节点
- [ ] 参考 LangGraph `update_instructions` 范式
- [ ] 设计自动更新触发条件
- [ ] 集成到心跳或对话结束流程

### 可执行方案（来自探索日志）

**第1轮发现**: 技能四元组 S=(C,π,T,R) + Memp框架
**第2轮发现**: Tom实战"人在环轻量反馈"+ 四阶段验证
**第3轮发现**: OpenClaw现成skill `self-reflection` by hopyky（MIT）+ hippocampus完整管线 + LangGraph `update_instructions` 范式

---

*本文件由系统自动维护，项目完成后归档到 `memory/topics/projects/archive/`*
