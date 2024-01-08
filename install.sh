# 設定ファイルを、全てホームディレクトリに向けてシンボリックリンクを貼ります。

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

#除外対象のファイル
exclude_files=(".git" ".github" ".DS_Store")

for dotfile in "${DOTFILES_DIR}"/.??*; do

    # ファイル名のみを取得（フルパスから）
    filename=$(basename "$dotfile")

    # 配列内の各要素と比較
    for exclude in "${exclude_files[@]}"; do
        if [[ "$filename" == "$exclude" ]]; then
            # 一致する場合は次のdotfileに進む
            continue 2
        fi
    done

    ln -fnsv "$dotfile" "$HOME"
done
