# My Harness 项目治理

本仓库是 `my-harness` Codex 插件的源码项目。后续维护、发布和分享都以本目录为事实源。

## 沟通和文档

- 默认使用中文沟通和撰写维护记录。
- 技术标识、skill 名称、命令、路径、错误信息保留英文。
- 面向公开使用者的 README 默认使用中文；具体命令、路径、skill 名称、技能提示词和英文专有名词可以保留英文。

## 源码边界

- 插件源码位于本仓库根目录。
- Codex 插件元数据位于 `.codex-plugin/plugin.json`。
- 技能统一放在 `skills/<skill-name>/SKILL.md`。
- 允许每个技能拥有自己的 `scripts/`、`templates/`、`references/`。
- 不要提交 `__pycache__`、`.pyc`、临时截图、运行日志或本机私有配置。

## 命名规则

- 插件名固定为 `my-harness`。
- 所有子技能使用 `my-harness-*` 前缀。
- 新技能优先使用 `my-harness-<verb>-<object>`。
- 新增技能后必须同步更新：
  - `skills/my-harness/SKILL.md` 路由表
  - `README.md` skill table
  - 如有流程变化，更新 `docs/project-history.md` 或 `docs/maintenance.md`

## 维护流程

1. 修改前先读相关 `SKILL.md` 和 README。
2. 保持每个 skill 单一职责，不把多个阶段揉进一个巨大 skill。
3. 技能 frontmatter `description` 必须以 `Use when` 开头。
4. 对会写文件的技能，说明保守合并规则、不会覆盖什么、完成检查是什么。
5. 修改后运行 `./scripts/verify.sh`。
6. 如需在本机试用，运行 `./scripts/install-local.sh` 同步到 Codex 本地插件目录。

## 发布边界

- 不自动 push、创建 release、打 tag 或发布新版本，除非用户明确授权。
- 公开仓库发布前必须确认 README、LICENSE、manifest、验证脚本和 skill 列表同步。
- 版本号以 `.codex-plugin/plugin.json` 为准；发布说明记录在 `CHANGELOG.md`。

## My Harness SOP 事实源

当前标准闭环为：

1. Discovery / Brainstorm gate：默认使用 gstack `/office-hours`；如果项目价值和目标已经明确、需要方案或 spec 收敛，可使用 Superpowers `brainstorming`
2. gstack `/plan-design-review`
3. Pencil prototype
4. gstack `/plan-design-review` on prototype
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout
14. gstack `/ship`
15. gstack `/land-and-deploy`

如果第 1 步使用了 Superpowers `brainstorming`，完成该门禁后不能直接进入 Superpowers `writing-plans`。除非当前需求极其简单、简单到无需设计评审和工程评审，否则必须先使用 `plan-design-review` 挑战产品、交互和前端方案，必要时使用 Pencil 策划原型，再使用 `plan-eng-review` 挑战工程方案，最后才能进入 `writing-plans`。

即便 Superpowers `brainstorming` 已经产出前后端实现方案，也只把它当作候选输入，后续仍要用 `plan-design-review` 和 `plan-eng-review` 重新挑战并打磨最佳方案。
