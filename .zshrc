# function
function mkcd(){ mkdir $1 && cd $1; }

# alias

## linux
alias a='alias'
alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep -E --color=auto'
alias setalias='vim ~/.zshrc && source ~/.zshrc && alias'
alias mkcd=mkcd
alias findr='find . -type f | grep -E'

## git command
alias g='git'
alias gb='git branch'
alias gl='git log --graph'
alias gst='git status'
alias gc='git add . && git commit'
alias gsc='git switch -c'
alias gsw='git switch'
alias gpl='git pull'
alias gps='git push'
alias gdf="gl | grep -m 2 commit | awk '{print \$NF}' | xargs -t git diff"
### only displays file name diff
alias gdfn="gl | grep -m 2 commit | awk '{print \$NF}' | xargs -t git diff --name-only"
alias y='yarn'
alias yd='yarn dev'
alias yb='yarn build'
alias ya='yarn add'

## docker command
alias d='docker'
alias dc='docker compose'
alias di='docker images'
alias dv='docker volume'
alias dn='docker network'
alias de='docker exec'

export LESSCHARSET=utf-8
