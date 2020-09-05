# My settings
# color settings
BLACK=$'\e[30m'   # Black - Regular
RED=$'\e[31m'     # Red
GREEN=$'\e[32m'   # Green
YELLOW=$'\e[33m'  # Yellow
BLUE=$'\e[34m'    # Blue
PURPLE=$'\e[35m'  # Purple
CYAN=$'\e[36m'    # Cyan
WHITE=$'\e[37m'   # White
GRAY=$'\e[90m'    # Gray
RESET=$'\e[m'

function check_result {
    if [ "$?" -eq 0 ]; then
        mark='  '
    else
        mark="${RED}✖${RESET} "
    fi
    echo -e "${mark} "
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# some more ls aliases
if which exa > /dev/null; then
    alias ls='exa'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:${PATH}"
fi
# cargo
if [ -d "${HOME}/.cargo/bin" ]; then
    PATH="${HOME}/.cargo/bin:${PATH}"
fi
# anyenv
if [ -d "${HOME}/.anyenv/bin" ]; then
    PATH="${HOME}/.anyenv/bin:${PATH}"
fi
# poetry
if [ -d "${HOME}/.poetry/bin" ]; then
    PATH="${HOME}/.poetry/bin:${PATH}"
fi

export PATH=${PATH}
if which anyenv > /dev/null; then
    eval "$(anyenv init -)"
fi

GIT_COMPLETION_PATH="${HOME}/.git-completion.bash"
GIT_PROMPT_PATH="${HOME}/.git-prompt.sh"

if [ -f ${GIT_COMPLETION_PATH} ]; then
    source $GIT_COMPLETION_PATH
fi
if [ -f $GIT_PROMPT_PATH ]; then
    source $GIT_PROMPT_PATH
fi

export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"
shopt -u histappend

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

if [ "$(type -t __git_ps1)" = "function" ]; then
    PS1="\[${YELLOW}\]\u\[${REST}\] \[${PURPLE}\]\w\[${RESET}\]\[${CYAN}\] "'$(__git_ps1 "(%s)")'"\[${RESET}\]\n\$(check_result)\$ "
else
    PS1="\[${YELLOW}\]\u\[${REST}\] \[${PURPLE}\]\w\[${RESET}\]\[${CYAN}\]\[${RESET}\]\n\$(check_result)\$ "
fi
export EDITOR='vim'
