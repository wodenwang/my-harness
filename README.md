# My Harness

`my-harness` 是一个 Codex 插件，用来封装个人项目交付 harness。它把 gstack、Superpowers、Pencil、浏览器验证和 Git 收口流程组合成一组可复用的技能。

这个插件刻意保持小而可组合：每个 skill 只负责一件事，有明确的证据规则和输出契约。

## 技能

| Skill | 用途 |
|---|---|
| `my-harness` | 路由技能，用来判断当前应该调用哪个 harness helper。 |
| `my-harness-next-action` | 读取项目证据，判断当前 SOP 步骤，输出完整 15 步状态表，并给出可复制的下一步提示词。 |
| `my-harness-writing-design` | 初始化项目设计治理：`DESIGN.md`、`design/`、Pencil starter，以及 `AGENTS.md` 中的设计规范链接；默认 Ant Design，可按用户明确倾向选择 shadcn/ui。 |
| `my-harness-autopilot-slice` | 在 `office-hours` 已定稿后，把一个小而边界清晰的版本切片推进完整 SOP，并在需要人工确认的门禁处停止。 |

## 标准 SOP

1. gstack `/office-hours`
2. gstack `/plan-design-review`
3. Pencil prototype
4. gstack `/plan-design-review` on prototype
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, with `open-gstack-browser` when visible real-time browser control is needed and Playwright as scripted fallback/regression coverage
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout
14. gstack `/ship`
15. gstack `/land-and-deploy`

## 已固化的设计决策

- Skill 名称统一使用 `my-harness-*` 前缀，确保归属清晰。
- `my-harness-next-action` 必须表格优先，使用 emoji 状态标记；如果 SOP 已闭环，不得重新建议从 `office-hours` 开始。
- `my-harness-next-action` 给出的推荐提示词必须放在独立的 fenced `text` 代码块中，方便一次复制。
- `my-harness-writing-design` 可以在可用时调用 Pencil 和所选 UI 框架相关 skill 或工具，但不能盲目生成或批准视觉设计。
- `my-harness-writing-design` 目前只支持 Ant Design 与 shadcn/ui；从零到一且用户没有明确倾向时默认使用 Ant Design + Ant Design Pro 后台布局风格，明确选择 shadcn/ui 时默认使用 shadcn/ui + tweakcn 后台主题风格，明确要求其他 UI 框架时必须拒绝。
- 如果用户提供主题色、官网、logo、截图或品牌素材，`my-harness-writing-design` 必须先解析素材，再选择 Ant Design token 或 tweakcn-compatible theme，而不是直接照搬营销视觉。
- `my-harness-autopilot-slice` 只适用于 `office-hours` 已定稿之后的小型、边界清晰切片。它会最多循环 10 次 `design-review`、`qa` 和 `review`，仍未解决时交给人工。
- autopilot 的完成、拒绝和交接都必须包含逐步汇总；循环次数、问题数量、修复和遗留情况合并写入“执行情况概要”，不要拆成多列数字；跳过的步骤也要列出，并说明为何跳过。

## 本地安装

在本仓库中运行：

```bash
./scripts/install-local.sh
```

脚本会把插件安装到：

```text
~/.codex/plugins/local/my-harness/plugins/my-harness
```

同时会写入本地 marketplace 文件，并在下面目录创建全局 skill symlink：

```text
~/.codex/skills/
```

如果当前 Codex 配置还没有启用这个插件，加入：

```toml
[plugins."my-harness@my-harness"]
enabled = true

[marketplaces.my-harness]
source = "/Users/wenzhewang/.codex/plugins/local/my-harness"
```

如果在另一台机器使用，需要把 marketplace 路径调整为那台机器上的 `$CODEX_HOME`。

## 验证

运行：

```bash
./scripts/verify.sh
```

验证脚本会检查：

- plugin manifest JSON 和必填字段
- 必需的 skill 目录
- skill frontmatter 中的 `name` 是否与目录名一致
- `description` 是否以 `Use when` 开头
- 仓库中没有提交 `__pycache__` 或 `.pyc` 产物

## 开发维护

本仓库是事实源。除临时本地实验外，不要直接编辑已安装副本。修改本仓库源码后运行：

```bash
./scripts/verify.sh
./scripts/install-local.sh
```

之后按需启动新的 Codex 会话，或刷新 skill discovery。

新增 harness helper 时：

1. Create `skills/my-harness-<verb>-<object>/SKILL.md`.
2. Update `skills/my-harness/SKILL.md` routing.
3. Update this README skill table，并保持 README 主体为中文。
4. Add any helper scripts/templates inside that skill directory.
5. Run `./scripts/verify.sh`.

## 仓库结构

```text
.codex-plugin/plugin.json
skills/
  my-harness/
  my-harness-next-action/
  my-harness-writing-design/
  my-harness-autopilot-slice/
docs/
scripts/
```

## 许可证

MIT
