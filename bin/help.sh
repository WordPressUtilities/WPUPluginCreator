#!/bin/bash

echo "# HELP";

cat <<EOF
wpuplugincreator add;               # Add features an existing plugin.
wpuplugincreator bump-version;      # Bump the version of an existing plugin.
wpuplugincreator create;            # Create a new plugin.
wpuplugincreator new-lang;          # Create a new language file.
wpuplugincreator plugin-check;      # Runs the plugin-check tool.
wpuplugincreator regenerate-lang;   # Regenerate the language files.
wpuplugincreator self-update;       # Update this tool.
wpuplugincreator src;               # Go to this tool install folder.
wpuplugincreator update;            # Update an existing plugin.
EOF

