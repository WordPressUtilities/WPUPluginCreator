#!/bin/bash

function wpuplugincreator_self_update_dependencies(){
    local _SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/../";
    cd ${_SOURCEDIR};
    git submodule foreach 'git checkout master; git checkout main; git pull origin';
    git add -A;
    git commit -m 'v TBD - Update dependencies';
}
wpuplugincreator_self_update_dependencies;
