# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 共通設定の読み込み
if [ -f ~/.shell_common ]; then
    . ~/.shell_common
fi


#　個別の設定
## プロンプト補完
autoload -Uz compinit
compinit
# 補完候補に色付け
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
## Powerlevel10kを使用
export ZSH_THEME="powerlevel10k/powerlevel10k"
## ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
## ターミナルフォーマット
export PROMPT="%F{magenta}%n%f:%F{yellow}%~%f %# "
## zsh向けのhomebrew PATH設定
export PATH="/opt/homebrew/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 各種 source コマンドの実施
source ~/.plugins/powerlevel10k/powerlevel10k.zsh-theme
source ~/.plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Created by `pipx` on 2025-05-11 11:30:16
export PATH="$PATH:/Users/nakajimahidenari/.local/bin"

# https://zenn.dev/oreo2990/articles/ba425684654b10#5-peco%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB
# peco settings
## 過去に実行したコマンドを選択。ctrl-rにバインド。
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^R' peco-select-history

## 過去に実行したディレクトリ移動を選択。ctrl-gにバインド。
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd `echo $selected_dir | awk '{print$2}'`"
    CURSOR=$#BUFFER
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^G' peco-cdr