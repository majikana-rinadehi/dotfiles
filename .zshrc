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
## zsh向けのhomebrew PATH設定 (macOSのみ)
if [[ "$(uname -s)" == "Darwin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

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

# Load zsh-syntax-highlighting with zinit (immediate loading for visual feedback)
zinit light zsh-users/zsh-syntax-highlighting

# Load zsh-autosuggestions with zinit (lazy loading with turbo mode)
zinit ice wait"1" lucid
zinit light zsh-users/zsh-autosuggestions

# Load zsh-completions with zinit (lazy loading with turbo mode)
zinit ice wait"2" lucid
zinit light zsh-users/zsh-completions

# zoxide setup
# プラットフォーム判定
if [[ "$(uname -s)" == "Darwin" ]]; then
  # macOS: brew を使用
  if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide with brew..."
    brew install zoxide
  fi
  
  if ! command -v fzf &> /dev/null; then
    echo "Installing fzf with brew (required for zoxide interactive mode)..."
    brew install fzf
  fi
elif [[ "$(uname -s)" == "Linux" ]]; then
  # Linux/Ubuntu: apt を優先使用
  if ! command -v zoxide &> /dev/null; then
    if command -v apt &> /dev/null; then
      echo "zoxide is not installed. Please install it:"
      echo "  sudo apt update && sudo apt install zoxide"
      echo ""
      echo "Note: If zoxide is not available in apt (Ubuntu < 22.04), install it with:"
      echo "  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
    else
      echo "zoxide is not installed. Please install it manually."
    fi
  fi
  
  if ! command -v fzf &> /dev/null; then
    if command -v apt &> /dev/null; then
      echo "fzf is not installed. Please install it:"
      echo "  sudo apt update && sudo apt install fzf"
    else
      echo "fzf is not installed. Please install it manually."
    fi
  fi
fi

# Initialize zoxide with custom alias to avoid conflict with zinit's zi
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd z)"
fi

# Create custom function for zoxide interactive mode to avoid zinit conflict
function zii() {
  local selected_dir="$(zoxide query -i)"
  if [ -n "$selected_dir" ]; then
    cd "$selected_dir"
  fi
}
