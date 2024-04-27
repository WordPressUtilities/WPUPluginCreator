#!/bin/bash

echo "# HELP";

cat <<EOF
wpuplugincreator add;               # Add features an existing plugin.
wpuplugincreator create;            # Create a new plugin.
wpuplugincreator update;            # Update an existing plugin.
wpuplugincreator self-update;       # Update this tool.
wpuplugincreator regenerate-lang;   # Regenerate the language files.
wpuplugincreator src;               # Go to this tool install folder.
EOF

