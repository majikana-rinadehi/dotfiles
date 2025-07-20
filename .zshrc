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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Zinit configuration
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load completions
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load powerlevel10k theme with zinit
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load zsh-syntax-highlighting with zinit
zinit light zsh-users/zsh-syntax-highlighting

# Load zsh-autosuggestions with zinit
zinit light zsh-users/zsh-autosuggestions

# Load zsh-completions with zinit
zinit light zsh-users/zsh-completions

# zoxide setup
# Auto-install zoxide with brew if not installed
if ! command -v zoxide &> /dev/null; then
  echo "Installing zoxide with brew..."
  brew install zoxide
fi

# Initialize zoxide
eval "$(zoxide init zsh)"
