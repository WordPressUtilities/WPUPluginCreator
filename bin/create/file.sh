#!/bin/bash

###################################
## Create file
###################################

echo '# Create plugin file';
mkdir "${_PLUGIN_DIR}";
cp "${_TOOLSDIR}skeleton.php" "${_PLUGIN_FILE}";
