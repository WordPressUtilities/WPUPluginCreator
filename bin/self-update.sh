#!/bin/bash

###################################
## Self-update
###################################

cd "${_SOURCEDIR}";
echo '# Submodules update';
git submodule update --init --recursive;
wpuplugincreator_install_wpcli;
cd "${_CURRENT_DIR}";
