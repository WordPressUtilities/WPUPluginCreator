#!/bin/bash

###################################
## Create file
###################################

echo '# Create plugin file';
mkdir "${_PLUGIN_DIR}";
cp "${_TOOLSDIR}skeleton.php" "${_PLUGIN_FILE}";


echo '# Create README';
cp "${_TOOLSDIR}README.md" "${_PLUGIN_DIR}README.md";
wpuplugincreator_set_values "${_PLUGIN_DIR}README.md";
