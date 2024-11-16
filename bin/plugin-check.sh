#!/bin/bash

wpuplugincreator_wpcli_command plugin install plugin-check --activate;
wpuplugincreator_wpcli_command plugin check $(basename "${_CURRENT_DIR}");
wpuplugincreator_wpcli_command plugin delete plugin-check;
