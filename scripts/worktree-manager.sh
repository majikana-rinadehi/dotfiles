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
    create|c <branch> [path]  新しいworktreeを作成
    list|l                    worktreeの一覧を表示
    delete|d|remove|rm [path] 指定されたworktreeを削除（引数なしでpeco選択）
    move|m|cd <name|path>     指定されたworktree名またはパスに移動
    select|s                  pecoでworktreeを選択して移動
    prune|p                   不要なworktreeエントリを削除
    help|h                    このヘルプを表示

例:
    ${SCRIPT_NAME} create feature/new-feature
    ${SCRIPT_NAME} create hotfix/bug-fix ../hotfix-repo
    ${SCRIPT_NAME} list
    ${SCRIPT_NAME} delete ../feature-repo
    ${SCRIPT_NAME} delete                 # pecoで選択
    ${SCRIPT_NAME} move feature-branch
    ${SCRIPT_NAME} select                 # pecoで選択して移動
    ${SCRIPT_NAME} prune

オプション:
    -h, --help               このヘルプを表示

詳細:
    create: 新しいブランチとworktreeを作成します。パスを指定しない場合は
            '../<branch-name>'を使用します。
    list:   現在のworktree一覧を表示します。
    delete: 指定されたパスのworktreeを削除します。パス未指定時はpecoで選択。
    move:   指定されたworktree名またはパスのディレクトリに移動します。
            ブランチ名で指定した場合、自動的にworktreeのパスを解決します。
    select: pecoを使ってworktreeを選択し、そのディレクトリに移動します。
    prune:  削除されたディレクトリに対応するworktreeエントリを削除します。
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

# Function to check if peco is available
check_peco() {
    if ! command -v peco >/dev/null 2>&1; then
        print_status "$RED" "エラー: pecoがインストールされていません"
        print_status "$YELLOW" "pecoをインストールしてください: brew install peco"
        return 1
    fi
    return 0
}

# Function to delete a worktree
delete_worktree() {
    local path="${1:-}"
    
    # If no path provided, use peco to select
    if [[ -z "$path" ]]; then
        check_peco || return 1
        
        local selected_worktree
        selected_worktree=$(git worktree list | grep -v "(bare)" | peco)
        
        if [[ -z "$selected_worktree" ]]; then
            print_status "$BLUE" "選択がキャンセルされました"
            return 0
        fi
        
        path=$(echo "$selected_worktree" | awk '{print $1}')
    fi
    
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

# Function to resolve worktree name to path
resolve_worktree_path() {
    local input="$1"
    
    # If input is already a path (contains / or starts with .), return as is
    if [[ "$input" == *"/"* ]] || [[ "$input" == "."* ]]; then
        echo "$input"
        return 0
    fi
    
    # Try to find worktree by name
    local worktree_info
    worktree_info=$(git worktree list --porcelain 2>/dev/null || true)
    
    if [[ -n "$worktree_info" ]]; then
        local current_path=""
        local current_branch=""
        
        while IFS= read -r line; do
            if [[ "$line" == worktree* ]]; then
                current_path="${line#worktree }"
            elif [[ "$line" == branch* ]]; then
                current_branch="${line#branch refs/heads/}"
                
                # Check if branch name matches input
                if [[ "$current_branch" == "$input" ]]; then
                    echo "$current_path"
                    return 0
                fi
                
                # Check if branch basename matches input (e.g., "feature" matches "feature/new-feature")
                if [[ "$(basename "$current_branch")" == "$input" ]]; then
                    echo "$current_path"
                    return 0
                fi
            fi
        done <<< "$worktree_info"
    fi
    
    # If not found as branch name, try as directory name pattern
    local repo_root
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    local parent_dir
    parent_dir=$(dirname "$repo_root")
    
    # Look for directories matching the pattern in parent directory
    local potential_paths=(
        "$parent_dir/$input"
        "$parent_dir/*$input*"
        "../$input"
        "../*$input*"
    )
    
    for pattern in "${potential_paths[@]}"; do
        for path in $pattern; do
            if [[ -d "$path" ]] && git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
                echo "$path"
                return 0
            fi
        done
    done
    
    # Return original input if nothing found
    echo "$input"
    return 1
}

# Function to move to a worktree
move_to_worktree() {
    local input="$1"
    
    if [[ -z "$input" ]]; then
        print_status "$RED" "エラー: 移動先のworktree名またはパスが指定されていません"
        return 1
    fi
    
    # Resolve input to actual path
    local path
    path=$(resolve_worktree_path "$input")
    local resolve_status=$?
    
    # Check if path exists
    if [[ ! -d "$path" ]]; then
        if [[ $resolve_status -eq 1 ]]; then
            print_status "$RED" "エラー: worktree '$input' が見つかりません"
            print_status "$YELLOW" "利用可能なworktree一覧:"
            git worktree list 2>/dev/null || true
        else
            print_status "$RED" "エラー: パス '$path' は存在しません"
        fi
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

# Function to select and move to a worktree using peco
select_worktree() {
    check_peco || return 1
    
    local selected_path
    selected_path=$(git worktree list | grep -v "(bare)" | awk '{print $1}' | peco)
    
    if [[ -n "$selected_path" ]]; then
        print_status "$GREEN" "worktreeに移動中: $selected_path"
        print_status "$YELLOW" "次のコマンドを実行してください:"
        print_status "$BLUE" "cd $selected_path"
    else
        print_status "$BLUE" "選択がキャンセルされました"
    fi
}

# Function to prune worktrees
prune_worktrees() {
    print_status "$BLUE" "不要なworktreeエントリを削除中..."
    
    if git worktree prune -v; then
        print_status "$GREEN" "pruneが正常に完了しました"
    else
        print_status "$RED" "エラー: pruneに失敗しました"
        return 1
    fi
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
            delete_worktree "${1:-}"
            ;;
        "move"|"m"|"cd")
            if [[ $# -eq 0 ]]; then
                print_status "$RED" "エラー: 移動先のworktree名またはパスが必要です"
                show_help
                exit 1
            fi
            move_to_worktree "$1"
            ;;
        "select"|"s")
            check_git_repo || exit 1
            select_worktree
            ;;
        "prune"|"p")
            check_git_repo || exit 1
            prune_worktrees
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