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
    case "$PLATFORM" in
        macOS)
            echo "macOS環境の初期化を実行..."
            # Homebrewが未インストールの場合の処理
            if ! command -v brew &> /dev/null; then
                echo "Homebrewがインストールされていません。"
                echo "https://brew.sh を参照してインストールしてください。"
                exit 1
            fi
            
            # zinitのインストール（Homebrewを使用）
            if ! command -v zinit &> /dev/null && [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
                echo "zinitをHomebrewでインストールしています..."
                brew install zinit
                echo "zinitのインストールが完了しました。"
            else
                echo "zinitは既にインストールされています。"
            fi
            ;;
        ubuntu)
            echo "Ubuntu環境の初期化を実行..."
            # 必要なパッケージの確認
            if ! command -v git &> /dev/null; then
                echo "gitがインストールされていません。"
                echo "sudo apt update && sudo apt install git を実行してください。"
                exit 1
            fi
            
            # zinitのインストール
            if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
                echo "zinitをインストールしています..."
                bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
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
    local backup_gitconfig="$HOME/.gitconfig.backup"
    
    # dotfilesに.gitconfigが存在しない場合はスキップ
    if [ ! -f "$dotfiles_gitconfig" ]; then
        echo ".gitconfig がdotfilesに存在しないため、スキップします。"
        return
    fi
    
    # 既存の.gitconfigがある場合
    if [ -f "$home_gitconfig" ]; then
        echo "既存の .gitconfig を検出しました。"
        
        # 既存の設定から user.name と user.email を抽出
        local user_name=$(git config --file "$home_gitconfig" user.name || echo "")
        local user_email=$(git config --file "$home_gitconfig" user.email || echo "")
        
        # バックアップを作成
        cp "$home_gitconfig" "$backup_gitconfig"
        echo "既存の .gitconfig を $backup_gitconfig にバックアップしました。"
        
        # dotfilesの.gitconfigをコピー
        cp "$dotfiles_gitconfig" "$home_gitconfig"
        echo "dotfilesの .gitconfig を適用しました。"
        
        # ユーザー固有の設定を復元
        if [ -n "$user_name" ]; then
            git config --global user.name "$user_name"
            echo "user.name を復元しました: $user_name"
        fi
        
        if [ -n "$user_email" ]; then
            git config --global user.email "$user_email"
            echo "user.email を復元しました: $user_email"
        fi
        
        # その他のローカル設定をincludeで読み込む設定を追加
        if ! grep -q "path = ~/.gitconfig.local" "$home_gitconfig"; then
            echo -e "\n[include]\n    path = ~/.gitconfig.local" >> "$home_gitconfig"
            echo ".gitconfig.local のinclude設定を追加しました。"
        fi
        
        # バックアップから.gitconfig.localを作成（ユーザー設定とinclude設定以外）
        if [ -f "$backup_gitconfig" ]; then
            # userセクション、include設定、および.gitconfig.localへの参照を除外
            grep -v -E "^\[user\]|^\[include\]|name =|email =|path = ~/\.gitconfig\.local" "$backup_gitconfig" > "$HOME/.gitconfig.local" 2>/dev/null || true
            echo "既存のカスタム設定を .gitconfig.local に保存しました。"
        fi
    else
        # 新規インストールの場合
        echo "既存の .gitconfig が見つかりませんでした。"
        cp "$dotfiles_gitconfig" "$home_gitconfig"
        echo "dotfilesの .gitconfig を新規作成しました。"
        
        # ユーザーに設定を促す
        echo ""
        echo "Git のユーザー情報を設定してください:"
        echo "  git config --global user.name \"Your Name\""
        echo "  git config --global user.email \"your.email@example.com\""
        echo ""
    fi
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
        .git | .github | .DS_Store | .shell_common | .gitconfig)
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
