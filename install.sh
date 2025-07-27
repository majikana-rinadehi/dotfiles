#!/bin/bash

# 設定ファイルを、全てホームディレクトリに向けてシンボリックリンクを貼ります。

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMON_FILE="${DOTFILES_DIR}"/.shell_common
echo "DOTFILES_DIR $DOTFILES_DIR"
echo "COMMON_FILE $COMMON_FILE"
echo "HOME $HOME"

# プラットフォーム判定
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo "macOS"
            ;;
        Linux*)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                if [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]]; then
                    echo "ubuntu"
                else
                    echo "linux"
                fi
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

PLATFORM=$(detect_platform)
echo "Detected platform: $PLATFORM"

# プラットフォーム固有の初期化処理
platform_init() {
    # 必要な依存関係を自動インストール
    echo "必要な依存関係をチェック・インストールしています..."
    if [ -f "${DOTFILES_DIR}/scripts/auto-install-deps.sh" ]; then
        if ! bash "${DOTFILES_DIR}/scripts/auto-install-deps.sh"; then
            echo "依存関係のインストールに失敗しました。"
            exit 1
        fi
    else
        echo "警告: 自動インストールスクリプトが見つかりません。"
        echo "手動で必要なパッケージ（git, curl, zsh）をインストールしてください。"
    fi
    
    case "$PLATFORM" in
        macOS)
            echo "macOS環境の初期化を実行..."
            
            # zinitのインストール（Homebrewを使用）
            if ! command -v zinit &> /dev/null && [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
                echo "zinitをHomebrewでインストールしています..."
                brew install zinit
                echo "zinitのインストールが完了しました。"
            else
                echo "zinitは既にインストールされています。"
            fi
            ;;
        ubuntu|linux)
            echo "Linux環境の初期化を実行..."
            
            # zinitのインストール
            if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
                echo "zinitをインストールしています..."
                echo "y" | bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
                echo "zinitのインストールが完了しました。"
            else
                echo "zinitは既にインストールされています。"
            fi
            ;;
        *)
            echo "サポートされていないプラットフォームです: $PLATFORM"
            exit 1
            ;;
    esac
}

# プラットフォーム初期化を実行
platform_init

ln -fnsv "$COMMON_FILE" "$HOME"
echo "Dotfile set $dotfile"

# .gitconfig の処理
handle_gitconfig() {
    local dotfiles_gitconfig="${DOTFILES_DIR}/.gitconfig"
    local home_gitconfig="$HOME/.gitconfig"
    local gitconfig_local="$HOME/.gitconfig.local"
    
    # dotfilesに.gitconfigが存在しない場合はスキップ
    if [ ! -f "$dotfiles_gitconfig" ]; then
        echo ".gitconfig がdotfilesに存在しないため、スキップします。"
        return
    fi
    
    # 既存の.gitconfig.localがある場合は削除
    if [ -f "$gitconfig_local" ]; then
        echo "既存の .gitconfig.local を削除します。"
        rm -f "$gitconfig_local"
    fi
    
    
    # dotfilesの.gitconfigへのシンボリックリンクを作成
    ln -snfv "$dotfiles_gitconfig" "$home_gitconfig"
    echo "dotfilesの .gitconfig へのシンボリックリンクを作成しました。"
    
    # ユーザーに設定を促す
    echo ""
    echo "Git のユーザー情報を設定してください:"
    echo "  git config --global user.name \"Your Name\""
    echo "  git config --global user.email \"your.email@example.com\""
    echo ""
}

# .gitconfig の処理を実行
handle_gitconfig


for dotfile in "${DOTFILES_DIR}"/.??*; do

    # ファイル名のみを取得（フルパスから）
    filename=$(basename "$dotfile")
    echo $filename

    # 特定のファイルを除外
    ## 仕方なく[[]]の使用を諦める...
    case "$filename" in
        .git | .github | .DS_Store | .shell_common)
            continue
            ;;
        *)
            # 除外対象外のファイルに対する処理
            ln -snfv "$dotfile" "$HOME"
            echo "Linked $dotfile to $HOME"
            ;;
    esac

done

# scriptsディレクトリ内のシェルスクリプトを$HOME/binにシンボリックリンク作成
echo "Creating symlinks for scripts in $HOME/bin..."

# $HOME/binディレクトリが存在しない場合は作成
mkdir -p "$HOME/bin"

# scriptsディレクトリ内の.shファイルを処理
if [ -d "${DOTFILES_DIR}/scripts" ]; then
    for script in "${DOTFILES_DIR}/scripts"/*.sh; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script" .sh)
            target_path="$HOME/bin/$script_name"
            
            # 既存のシンボリックリンクがある場合は削除
            if [ -L "$target_path" ]; then
                rm "$target_path"
            fi
            
            # シンボリックリンクを作成
            ln -s "$script" "$target_path"
            echo "Created symlink: $target_path -> $script"
        fi
    done
fi

# インストール完了後にシェル設定を再読み込み
echo ""
echo "インストールが完了しました。"
echo "現在のシェルセッションに設定を反映しています..."

# 現在のシェルがzshの場合、.zshrcを再読み込み
if [ -n "$ZSH_VERSION" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        echo "zsh設定を再読み込みしています..."
        source "$HOME/.zshrc" 2>/dev/null && echo "✓ zsh設定の再読み込みが完了しました。" || echo "! zsh設定の再読み込みでエラーが発生しましたが、新しいターミナルでは正常に動作します。"
    fi
elif [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        echo "bash設定を再読み込みしています..."
        source "$HOME/.bashrc" 2>/dev/null && echo "✓ bash設定の再読み込みが完了しました。" || echo "! bash設定の再読み込みでエラーが発生しましたが、新しいターミナルでは正常に動作します。"
    fi
fi

echo ""
echo "🎉 dotfilesのセットアップが完了しました！"
echo "新しい機能やコマンドが利用可能になりました。"
