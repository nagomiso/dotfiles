autoload -U compinit
compinit
source $HOME/.git-prompt.sh
# 文字コード設定
export LANG=ja_JP.UTF-8

#カラー設定
if [ -e /usr/share/terminfo/x/xterm-256color ] || [ -e /lib/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

# zmv設定
autoload -Uz zmv

autoload -Uz colors
colors
# 履歴設定 
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups # 重複除去

setopt correct
setopt list_packed
setopt nolistbeep

# 色設定
setopt PROMPT_SUBST
GIT_PS1_SHOWDIRTYSTATE=true
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
PROMPT='%B%F{green}%n%b %B%F{cyan}% $%b%f$(__git_ps1 " (%s)") '
RPROMPT='%F{yellow}[%m:%~]%f'

# alias
alias ls="ls -F --color=auto"
alias la="ls -a"
alias ll="ls -l"
alias vim="nvim"
alias vi="nvim"
alias gvim="pynvim"

# TeXLive
if [ -d /usr/local/texlive/2016 ]
then
  export PATH=/usr/local/texlive/2016/bin/x86_64-linux:$PATH
fi

# nvimの設定ファイルを配置するディレクトリ
export XDG_CONFIG_HOME=$HOME/.config

# デフォルトのエディタ設定
export EDITOR=nvim

if [ -d $HOME/.anyenv ]
then
  export PATH=$HOME/.anyenv/bin:$PATH
  eval "$(anyenv init -)"
fi
export LD_LIBRARY_PATH=/opt/openssl-1.0.2k/lib:/opt/mariadb-10.1.21/lib
export PATH=/opt/mariadb-10.1.21/bin:/opt/mariadb-10.1.21/scripts:$PATH
