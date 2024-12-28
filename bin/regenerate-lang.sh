#!/bin/bash

if [[ -d "${_CURRENT_DIR}lang" && $(pwd) != *"wp-content/themes"* ]];then
    wpuplugincreator_regenerate_languages "${_CURRENT_DIR}lang";
fi;
