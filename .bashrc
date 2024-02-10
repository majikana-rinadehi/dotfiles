# 共通設定の読み込み
if [ -f ~/.shell_common ]; then
    echo ".shell_common exists"
    . ~/.shell_common
fi