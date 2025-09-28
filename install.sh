#!/bin/bash

# Claude Code 配置安装脚本
# 用于安装自定义的 commands, agents 和 hooks

set -e  # 遇到错误时退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 函数：检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 主安装函数
main() {
    print_info "开始安装 Claude Code 配置..."

    # 检查当前目录是否包含配置文件
    if [[ ! -d "commands" ]] || [[ ! -d "agents" ]] || [[ ! -d "hooks" ]]; then
        print_error "当前目录缺少必要的配置文件夹 (commands, agents, hooks)"
        print_error "请确保在正确的仓库目录中运行此脚本"
        exit 1
    fi

    # Claude 配置目录
    CLAUDE_DIR="$HOME/.claude"

    # 检查 ~/.claude 目录是否存在
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        print_warning "~/.claude 目录不存在，正在创建..."
        mkdir -p "$CLAUDE_DIR"
        print_success "已创建 ~/.claude 目录"
    else
        print_info "发现现有的 ~/.claude 目录"
    fi

    # 备份现有配置（如果存在）
    backup_existing_config() {
        local config_type="$1"
        local target_dir="$CLAUDE_DIR/$config_type"

        if [[ -d "$target_dir" ]] && [[ -n "$(ls -A "$target_dir" 2>/dev/null)" ]]; then
            local backup_dir="$CLAUDE_DIR/${config_type}.backup.$(date +%Y%m%d_%H%M%S)"
            print_warning "备份现有的 $config_type 配置到: $backup_dir"
            mv "$target_dir" "$backup_dir"
            mkdir -p "$target_dir"
        else
            mkdir -p "$target_dir"
        fi
    }

    # 安装配置文件
    install_config() {
        local config_type="$1"
        local source_dir="$config_type"
        local target_dir="$CLAUDE_DIR/$config_type"

        print_info "安装 $config_type 配置..."

        # 备份现有配置
        backup_existing_config "$config_type"

        # 复制配置文件
        if cp -r "$source_dir/"* "$target_dir/" 2>/dev/null; then
            local count=$(find "$source_dir" -type f | wc -l | tr -d ' ')
            print_success "已安装 $count 个 $config_type 配置文件"
        else
            print_error "安装 $config_type 配置失败"
            exit 1
        fi
    }

    # 安装各类配置
    install_config "commands"
    install_config "agents"
    install_config "hooks"

    # 设置 hooks 脚本权限
    print_info "设置 hooks 脚本权限..."
    find "$CLAUDE_DIR/hooks" -name "*.py" -exec chmod +x {} \; 2>/dev/null || true
    find "$CLAUDE_DIR/hooks" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    print_success "已设置 hooks 脚本权限"

    # 安装完成
    echo
    print_success "Claude Code 配置安装完成！"
    echo
    print_info "已安装的配置："
    echo "  • Commands: $(find "$CLAUDE_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') 个"
    echo "  • Agents: $(find "$CLAUDE_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') 个"
    echo "  • Hooks: $(find "$CLAUDE_DIR/hooks" -type f 2>/dev/null | wc -l | tr -d ' ') 个"
    echo
    print_info "您现在可以在 Claude Code 中使用这些配置了！"

    # 提示用户重启 Claude Code（如果正在运行）
    if command_exists "pgrep" && pgrep -f "claude" >/dev/null 2>&1; then
        echo
        print_warning "建议重启 Claude Code 以确保新配置生效"
    fi
}

# 显示帮助信息
show_help() {
    echo "Claude Code 配置安装脚本"
    echo
    echo "用法: $0 [选项]"
    echo
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -v, --version  显示版本信息"
    echo
    echo "此脚本会将当前目录中的 commands, agents 和 hooks 配置"
    echo "安装到 ~/.claude 目录中。"
    echo
    echo "现有配置会被自动备份。"
}

# 处理命令行参数
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        echo "Claude Code 配置安装脚本 v1.0.0"
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_error "未知选项: $1"
        print_info "使用 --help 查看帮助信息"
        exit 1
        ;;
esac