# 共通設定の読み込み
if [ -f ~/.shell_common ]; then
    . ~/.shell_common
    echo "Successfully loaded ~/.shell_common !"
fi

#　個別の設定
## zsh向けのhomebrew PATH設定
export PATH="/opt/homebrew/bin:$PATH"
