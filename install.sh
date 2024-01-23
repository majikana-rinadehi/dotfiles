#!/bin/bash

# 設定ファイルを、全てホームディレクトリに向けてシンボリックリンクを貼ります。

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
echo $DOTFILES_DIR

for dotfile in "${DOTFILES_DIR}"/.??*; do

    # ファイル名のみを取得（フルパスから）
    filename=$(basename "$dotfile")
    echo $filename

    # 特定のファイルを除外
    ## 仕方なく[[]]の使用を諦める...
    if "$filename" == ".git"; then
        continue
    fi

    if "$filename" == ".github"; then
        continue
    fi
    
    if "$filename" == ".DS_Store" ]]; then
        continue
    fi

    ln -fnsv "$dotfile" "$HOME"
    echo $dotfile
done
