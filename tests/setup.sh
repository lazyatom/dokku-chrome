#!/usr/bin/env bash
set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/test_helper.bash"
source "$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")/config"
export DOKKU_INSTALL_ROOT=/var/lib/dokku

echo "Uninstalling plugin and clearing data..."
sudo dokku plugin:uninstall $PLUGIN_COMMAND_PREFIX || true
sudo rm -fr $CHROME_ROOT $PLUGIN_DATA_ROOT $PLUGIN_CONFIG_ROOT

echo "Linking plugin files..."
sudo -u dokku mkdir -p $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX/subcommands
sudo -u dokku find ./ -maxdepth 1 -type f -exec cp '{}' $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX \;
sudo -u dokku find ./subcommands -maxdepth 1 -type f -exec cp '{}' $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX/subcommands \;

echo "Enabling plugin and running installation..."
sudo -u dokku ln -s $DOKKU_INSTALL_ROOT/plugins/available/$PLUGIN_COMMAND_PREFIX $DOKKU_INSTALL_ROOT/plugins/enabled/$PLUGIN_COMMAND_PREFIX
sudo dokku plugin:install
