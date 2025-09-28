# Claude Code 配置分享

这个仓库包含了个人的 Claude Code 配置，包括自定义命令、代理和 hooks。您可以使用这些配置来增强您的 Claude Code 工作环境。

## 包含的配置

### Commands (命令)
- **commit.md** - Git 提交相关命令
- **implement.md** - 功能实现命令
- **knowledge.md** - 知识管理命令
- **review.md** - 代码审查命令
- **specify.md** - 需求分析命令

### Agents (代理)
- **code-reviewer.md** - 代码审查代理
- **git-commit-generator.md** - Git 提交信息生成代理

### Hooks
- **ultrathink_hook.py** - 用户提示提交钩子

## 安装方法

### 快速安装

```bash
# 克隆仓库
git clone <此仓库地址>
cd claude-config

# 运行安装脚本
./install.sh
```

### 手动安装

```bash
# 复制配置到 Claude 目录
cp -r commands ~/.claude/
cp -r agents ~/.claude/
cp -r hooks ~/.claude/
```

## 更新配置

当仓库有新的配置更新时：

```bash
# 拉取最新配置
git pull

# 重新运行安装脚本
./install.sh
```

## 配置说明

### Commands
自定义命令可以通过 `/命令名` 的方式在 Claude Code 中使用。

### Agents
代理配置定义了专门的 AI 助手，可以处理特定类型的任务。

### Hooks
Hooks 允许在特定事件发生时执行自定义脚本。

## 系统要求

- Claude Code 已安装
- macOS 或 Linux 系统
- Bash shell

## 注意事项

- 安装脚本会覆盖您现有的同名配置文件
- 建议在安装前备份您现有的 `~/.claude` 配置
- `settings.json` 等个人敏感配置不包含在此仓库中

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这些配置。

## 许可证

MIT License