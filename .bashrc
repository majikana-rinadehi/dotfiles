# 共通設定の読み込み
if [ -f ~/.shell_common ]; then
    . ~/.shell_common
fi
if [ -n "$PS1" ]; then
    echo "Successfully loaded ~/.shell_common !"
fi