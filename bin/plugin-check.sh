#!/bin/bash

wp plugin install plugin-check --activate;
wp plugin check $(basename "${_CURRENT_DIR}");
wp plugin delete plugin-check;
