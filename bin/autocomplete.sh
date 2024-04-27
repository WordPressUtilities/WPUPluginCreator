#!/bin/bash

###################################
## Autocomplete commands
###################################

_wpuplugincreator_complete() {
    local cur prev prev2

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $(compgen -W "add create help regenerate-lang self-update src update" -- $cur) )
    fi

    return 0
}

complete -F _wpuplugincreator_complete wpuplugincreator

