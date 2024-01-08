# 設定ファイルを、全てホームディレクトリに向けてシンボリックリンクを貼ります。

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

for dotfile in "${DOTFILES_DIR}"/.??*; do

    # ファイル名のみを取得（フルパスから）
    filename=$(basename "$dotfile")

    # 特定のファイルを除外
    if [[ "$filename" == ".git" || "$filename" == ".github" || "$filename" == ".DS_Store" ]]; then
        continue
    fi

    ln -fnsv "$dotfile" "$HOME"
done