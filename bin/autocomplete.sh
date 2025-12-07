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
        COMPREPLY=($(compgen -W "add bump-version create help new-lang plugin-check regenerate-lang self-update src update upgrade-wpubaseplugin" -- $cur))
    elif [ $COMP_CWORD -eq 2 ]; then
        case "${prev}" in
            'add' | 'upgrade-wpubaseplugin')
                COMPREPLY=($(compgen -W "${modules_list}" -- $cur))
            ;;
            'bump-version')
                COMPREPLY=($(compgen -W "major minor patch" -- $cur))
            ;;
            'new-lang')
                COMPREPLY=($(compgen -W "en_US es_ES fr_FR de_DE it_IT pt_BR ru_RU zh_CN ja_JP nl_NL" -- $cur))
            ;;
            'update')
                COMPREPLY=($(compgen -W "all only-dependencies" -- $cur))
            ;;
        esac
    fi

    return 0
}

complete -F _wpuplugincreator_complete wpuplugincreator

