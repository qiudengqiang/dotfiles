#!/usr/bin/env bash

# Bash-only interactive settings.
[[ $- != *i* ]] && return

# HSTR integration (only when installed)
if command -v hstr >/dev/null 2>&1; then
  alias hh='hstr'
  export HSTR_CONFIG='hicolor'
  shopt -s histappend
  export HISTCONTROL='ignorespace'
  export HISTFILESIZE='10000'
  export HISTSIZE="${HISTFILESIZE}"
  if [[ "${PROMPT_COMMAND:-}" != *"history -a; history -n"* ]]; then
    export PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}"
  fi
  bind '"\C-r": "\C-a hstr -- \C-j"'
  bind '"\C-xk": "\C-a hstr -k \C-j"'
  export HSTR_TIOCSTI='y'
fi
