# Completion
autoload -U compinit
compinit
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes

# History
HISTFILE=~/.zsh_history         # where to store zsh config
HISTSIZE=1024                   # big history
SAVEHIST=1024                   # big history
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks

# Editor behaviour
bindkey -v
export EDITOR='vim'
bindkey '^r' history-incremental-pattern-search-backward
bindkey "^p" vi-up-line-or-history
bindkey "^n" vi-down-line-or-history
print -Pn "\e]0; %n@%M: %~\a"
setopt autocd
setopt extendedglob
unsetopt beep
unsetopt hist_beep
unsetopt list_beep

# z
# . /usr/local/etc/profile.d/z.sh

# Prompt
autoload -U colors 
colors
setopt PROMPT_SUBST
local ret_status="%(?:%{$fg[cyan]%}%c%{$reset_color%}:%{$fg_bold[red]%}%c%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"

function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

git_custom_prompt() {
  # branch name (.oh-my-zsh/plugins/git/git.plugin.zsh)
  local branch=$(git_current_branch)
  if [ -n "$branch" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$branch$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

PROMPT='${ret_status} '
RPROMPT='$(git_custom_prompt)'

# From zsh-users. Needs to after zsh config statements.
source /opt/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Minishift
start_minishift () {
  minishift start --metrics --cpus 4 --memory 8GB --openshift-version 3.7.0
  eval $(minishift docker-env)
  eval $(minishift oc-env)
  source <(oc completion zsh)
}

# Aliases
alias ll='ls -FGhal'
alias ...='../..'
alias ....='../../..'
alias mvim=/Applications/MacVim.app/Contents/bin/mvim

# Exports
export GRADLE_HOME=/usr/local/opt/gradle/libexec

echo '
  _____  ____    _   _
 |__  / / ___|  | | | |
   / /  \___ \  | |_| |
  / /_   ___) | |  _  |
 /____| |____/  |_| |_|

 '
#source /opt/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
