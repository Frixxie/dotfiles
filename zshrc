#Configuration originally written by Luke smith, Modified by Fredrik Hagen Fasteraune.

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zshhist

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

GPG_TTY=$(tty)
export GPG_TTY


# Load z
eval "$(lua $HOME/osrc/z.lua/z.lua --init zsh)"

# Aliases:
alias ls='exa'
alias nv='nvim'
alias j='z'
alias :e="nvim"
alias :q='exit'
alias c='clear'
alias news='newsboat'
alias zat='zathura'
alias upgrade='doas emerge --ask --update --deep --with-bdeps=y --newuse @world'

# Exports:
export EDITOR=nvim
export PATH="$PATH:/home/fredrik/.cargo/bin/"
export PATH="$PATH:/home/fredrik/.local/bin/"
export PATH="$PATH:/home/fredrik/go/bin/"
export PATH="$PATH:/usr/local/bin/"
export PATH="$PATH:/usr/local/upcxx/bin/"
export PATH="$PATH:/home/fredrik/.local/bin/"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/home/fredrik/other_sources/arduino-cli/bin"
export MANPAGER="nvim +Man! -c ':set signcolumn='"
export BROWSER="firefox"
export PATH="/usr/lib/ccache/bin:${PATH}"
export DISTCC_DIR="/home/fredrik/.distcc"
export TERM="xterm"
export CCACHE_RECACHE="yes"
export CCACHE_DIR="/var/cache/ccache"
export MAKEFLAGS='-j4'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ ${FEATURES} == *ccache* && ${EBUILD_PHASE_FUNC} == src_* ]]; then
	if [[ ${CCACHE_DIR} == /var/cache/ccache ]]; then
		export CCACHE_DIR=/var/cache/ccache/${CATEGORY}/${PN}:${SLOT}
		mkdir -p "${CCACHE_DIR}" || die
	fi
fi

# Load zsh-syntax-highlighting; should be last.
source $HOME/osrc/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /home/fredrik/.config/broot/launcher/bash/br
