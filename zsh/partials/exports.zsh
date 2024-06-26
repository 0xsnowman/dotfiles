export VIRTUAL_ENV_DISABLE_PROMPT="true"

export BUNDLE_EDITOR="nvim"
export EDITOR="nvim"

export HISTCONTROL="ignoreboth:erasedups"
export HISTSIZE=500000
export SAVEHIST=500000

export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [[ -z $XDG_CONFIG_HOME ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi
