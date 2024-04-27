#!/bin/bash

if [[ -d "${_CURRENT_DIR}lang" ]];then
    wpuplugincreator_regenerate_languages "${_CURRENT_DIR}lang";
fi;
