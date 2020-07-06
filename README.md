# WPU Plugin Creator

Quickly Create a WordPress Plugin

## How to install on your machine

Go to your favorite tools folder :

```
git clone https://github.com/WordPressUtilities/WPUPluginCreator

```
Add CLI shortcut :

```
. WPUPluginCreator/inc/installer.sh;
```

## Road to MVP

- [x] Add an installer.
- [x] Add WPUBasePlugin as submodule for the tool.
- [x] Ask the plugin name, generate Class Name & Project ID.
- [x] Generate a simple plugin skeleton with basic hooks.

## Features

- [x] Add translation (ask language).
- [x] Add a settings page.
- [x] Load CSS in back-office.
- [x] Load JS in back-office.
- [x] Load CSS in front-office.
- [x] Load JS in front-office.
- [x] Add an admin page.
- [x] Add a database option.
- [x] Add messages.
- [ ] Default content for generated CSS/JS assets (with placeholder replace).
- [ ] Register a post-type (ask id / name).
- [ ] Register a taxonomy (ask id / name).
- [ ] Add a plugin update option.
- [ ] Unit tests.


## Quality of life

- [ ] Self update.
- [ ] Ask the plugin repository ( to clone or add as a remote )
- [ ] Check if this is a WordPress plugin folder ? ( Just an alert, non blocking )


