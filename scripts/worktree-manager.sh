#!/bin/bash

# Git Worktree Management Script
# This script provides utilities for managing Git worktrees

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
SCRIPT_NAME="$(basename "$0")"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print help message
show_help() {
    cat << EOF
${SCRIPT_NAME} - Git Worktree管理ツール

使用法:
    ${SCRIPT_NAME} <command> [options]

コマンド:
    create <branch> [path]    新しいworktreeを作成
    list                      worktreeの一覧を表示
    delete <path>             指定されたworktreeを削除
    move <path>               指定されたworktreeに移動
    help                      このヘルプを表示

例:
    ${SCRIPT_NAME} create feature/new-feature
    ${SCRIPT_NAME} create hotfix/bug-fix ../hotfix-repo
    ${SCRIPT_NAME} list
    ${SCRIPT_NAME} delete ../feature-repo
    ${SCRIPT_NAME} move ../feature-repo

オプション:
    -h, --help               このヘルプを表示

詳細:
    create: 新しいブランチとworktreeを作成します。パスを指定しない場合は
            '../<branch-name>'を使用します。
    list:   現在のworktree一覧を表示します。
    delete: 指定されたパスのworktreeを削除します。
    move:   指定されたworktreeのディレクトリに移動します。
EOF
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_status "$RED" "エラー: このディレクトリはGitリポジトリではありません"
        return 1
    fi
    return 0
}

# Function to create a new worktree
create_worktree() {
    local branch="$1"
    local path="${2:-}"
    
    # Validate branch name
    if [[ -z "$branch" ]]; then
        print_status "$RED" "エラー: ブランチ名が指定されていません"
        return 1
    fi
    
    # Set default path if not provided
    if [[ -z "$path" ]]; then
        path="../$(basename "$branch")"
    fi
    
    print_status "$BLUE" "worktreeを作成中: ブランチ=$branch, パス=$path"
    
    # Check if path already exists
    if [[ -e "$path" ]]; then
        print_status "$RED" "エラー: パス '$path' は既に存在します"
        return 1
    fi
    
    # Create worktree
    if git worktree add -b "$branch" "$path"; then
        print_status "$GREEN" "worktreeが正常に作成されました: $path"
        print_status "$YELLOW" "移動するには: cd $path"
    else
        print_status "$RED" "エラー: worktreeの作成に失敗しました"
        return 1
    fi
}

# Function to list worktrees
list_worktrees() {
    print_status "$BLUE" "worktree一覧:"
    if git worktree list; then
        return 0
    else
        print_status "$RED" "エラー: worktree一覧の取得に失敗しました"
        return 1
    fi
}

# Function to delete a worktree
delete_worktree() {
    local path="$1"
    
    if [[ -z "$path" ]]; then
        print_status "$RED" "エラー: 削除するworktreeのパスが指定されていません"
        return 1
    fi
    
    # Confirm deletion
    print_status "$YELLOW" "worktreeを削除しようとしています: $path"
    read -p "続行しますか? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "$BLUE" "キャンセルされました"
        return 0
    fi
    
    # Delete worktree
    if git worktree remove "$path"; then
        print_status "$GREEN" "worktreeが正常に削除されました: $path"
    else
        print_status "$RED" "エラー: worktreeの削除に失敗しました"
        return 1
    fi
}

# Function to move to a worktree
move_to_worktree() {
    local path="$1"
    
    if [[ -z "$path" ]]; then
        print_status "$RED" "エラー: 移動先のworktreeパスが指定されていません"
        return 1
    fi
    
    # Check if path exists
    if [[ ! -d "$path" ]]; then
        print_status "$RED" "エラー: パス '$path' は存在しません"
        return 1
    fi
    
    # Check if path is a git worktree
    if ! git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
        print_status "$RED" "エラー: '$path' はGitワーキングディレクトリではありません"
        return 1
    fi
    
    print_status "$GREEN" "worktreeに移動中: $path"
    print_status "$YELLOW" "次のコマンドを実行してください:"
    print_status "$BLUE" "cd $path"
}

# Main function
main() {
    # Check if no arguments provided
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    # Parse command line arguments
    local command="$1"
    shift
    
    case "$command" in
        "create"|"c")
            check_git_repo || exit 1
            if [[ $# -eq 0 ]]; then
                print_status "$RED" "エラー: ブランチ名が必要です"
                show_help
                exit 1
            fi
            create_worktree "$@"
            ;;
        "list"|"l")
            check_git_repo || exit 1
            list_worktrees
            ;;
        "delete"|"d"|"remove"|"rm")
            check_git_repo || exit 1
            if [[ $# -eq 0 ]]; then
                print_status "$RED" "エラー: 削除するworktreeのパスが必要です"
                show_help
                exit 1
            fi
            delete_worktree "$1"
            ;;
        "move"|"m"|"cd")
            if [[ $# -eq 0 ]]; then
                print_status "$RED" "エラー: 移動先のworktreeパスが必要です"
                show_help
                exit 1
            fi
            move_to_worktree "$1"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_status "$RED" "エラー: 不明なコマンド '$command'"
            show_help
            exit 1
            ;;
    esac
}

# Run the script only if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi