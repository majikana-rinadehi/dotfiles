#!/bin/bash

# 設定ファイルを、全てホームディレクトリに向けてシンボリックリンクを貼ります。

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMON_FILE="${DOTFILES_DIR}"/.shell_common
echo "DOTFILES_DIR $DOTFILES_DIR"
echo "COMMON_FILE $COMMON_FILE"
echo "HOME $HOME"

ln -fnsv "$COMMON_FILE" "$HOME"
echo "Dotfile set $dotfile"

# 既存の.gitconfigを.gitconfig_local にバックアップし、dotfilesのものを適用します
if [ -f "$HOME/.gitconfig" ]; then
    echo "既存の .gitconfig をバックアップします..."
    mv "$HOME/.gitconfig" "$HOME/.gitconfig_local"
else
    echo "既存の .gitconfig は見つかりませんでした。"
    echo "空の.gitconfig_local を作成します..."
    touch "$HOME/.gitconfig_local"
fi


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
