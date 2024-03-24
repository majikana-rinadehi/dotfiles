# 共通設定の読み込み
if [ -f ~/.shell_common ]; then
    . ~/.shell_common
    echo "Successfully loaded ~/.shell_common !"
fi

#　個別の設定
## ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
## ターミナルフォーマット
export PROMPT="%F{magenta}%n%f:%F{yellow}%~%f %# "
## zsh向けのhomebrew PATH設定
export PATH="/opt/homebrew/bin:$PATH"
