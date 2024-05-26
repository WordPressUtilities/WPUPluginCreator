#!/bin/bash

###################################
## Autocomplete commands
###################################

_wpuplugincreator_complete() {
    local cur prev;

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    local modules_list="WPUBaseAdminDatas WPUBaseAdminPage WPUBaseCron WPUBaseMessages WPUBaseSettings WPUBaseUpdate WPUBaseFields WPUBaseEmail WPUBaseToolbox WPUBaseFileCache";

    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "add create help regenerate-lang self-update src update upgrade-wpubaseplugin" -- $cur))
    elif [ $COMP_CWORD -eq 2 ]; then
        case "${prev}" in
        'add' | 'upgrade-wpubaseplugin')
            COMPREPLY=($(compgen -W "${modules_list}" -- $cur))
            ;;
        esac
    fi

    return 0
}

complete -F _wpuplugincreator_complete wpuplugincreator

