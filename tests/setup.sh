#!/usr/bin/env bash
set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/test_helper.bash"
source "$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")/config"
export DOKKU_INSTALL_ROOT=/var/lib/dokku

# Remove the plugin if it's already installed
sudo dokku plugin:uninstall $PLUGIN_COMMAND_PREFIX || true
sudo rm -fr $DOKKU_INSTALL_ROOT/services/$PLUGIN_COMMAND_PREFIX
sudo rm -fr $DOKKU_INSTALL_ROOT/config/$PLUGIN_COMMAND_PREFIX
sudo rm -fr $DOKKU_INSTALL_ROOT/data/$PLUGIN_COMMAND_PREFIX

# Copy the plugin files into place
sudo -u dokku mkdir -p $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX/subcommands
sudo -u dokku find ./ -maxdepth 1 -type f -exec cp '{}' $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX \;
sudo -u dokku find ./subcommands -maxdepth 1 -type f -exec cp '{}' $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX/subcommands \;

# Enable and install the plugin
sudo -u dokku ln -s $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX $DOKKU_INSTALL_ROOT/plugins/enabled/$PLUGIN_COMMAND_PREFIX
sudo dokku plugin:install
