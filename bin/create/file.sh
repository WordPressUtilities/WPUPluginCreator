#!/bin/bash

###################################
## Create file
###################################

echo '# Create plugin file';
cp "${_TOOLSDIR}skeleton.php" "${_PLUGIN_FILE}";

echo '# Create README';
cp "${_TOOLSDIR}README.md" "${_PLUGIN_DIR}README.md";
wpuplugincreator_set_values "${_PLUGIN_DIR}README.md";

echo '# Create other files';
echo "<?php // Silence is Golden " > "${_PLUGIN_DIR}index.php";
