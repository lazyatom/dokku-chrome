# dokku chrome

A headless browser service for dokku which can be used by applications to generate PDFs, take screenshots and so on.

This service runs a Chrome browser via the [browserless/chrome](https://hub.docker.com/r/browserless/chrome) image from Docker. This image is kindly provided by [browserless](https://browserless.io), and if you are planning to use it as part of a commercial service, you must [purchase a license](https://www.browserless.io/commercial-license). However, it is free for use by open-source projects.

One of the main benefits of the browserless docker image is that it includes a REST API which can be used to easily generate PDFs, screenshots and so on. REST API documentation can be found at https://docs.browserless.io/docs/pdf.html

## Requirements

- dokku 0.8.1+
- docker 1.8.x

## Installation

```shell
# on 0.4.x+
sudo dokku plugin:install https://github.com/lazyatom/dokku-chrome.git chrome
```

## Commands

```
chrome:app-links <app>          List all chrome service links for a given app
chrome:create <name>            Create a chrome service with environment variables
chrome:destroy <name>           Delete the service, delete the data and stop its container if there are no links left
chrome:enter <name> [command]   Enter or run a command in a running chrome service container
chrome:exists <service>         Check if the chrome service exists
chrome:expose <name> [port]     Expose a chrome service on custom port if provided (random port otherwise)
chrome:info <name>              Print the connection information
chrome:link <name> <app>        Link the chrome service to the app
chrome:linked <name> <app>      Check if the chrome service is linked to an app
chrome:list                     List all chrome services
chrome:logs <name> [-t]         Print the most recent log(s) for this service
chrome:promote <name> <app>     Promote service <name> as CHROME_URL in <app>
chrome:restart <name>           Graceful shutdown and restart of the chrome service container
chrome:start <name>             Start a previously stopped chrome service
chrome:stop <name>              Stop a running chrome service
chrome:unexpose <name>          Unexpose a previously exposed chrome service
chrome:unlink <name> <app>      Unlink the chrome service from the app
chrome:upgrade <name>           Upgrade service <service> to the specified version
```

## Rsage

```shell
# Create a chrome service named lolipop
dokku chrome:create lolipop

# You can also specify the image and image
# version to use for the service
# it *must* be compatible with the
# official browserless/chrome image
export CHROME_IMAGE="browserless/chrome"
export CHROME_IMAGE_VERSION="1.6.2"
dokku chrome:create lolipop

# You can also specify custom environment
# variables to start the chrome service
# in semi-colon separated form
export CHROME_CUSTOM_ENV="MAX_CONCURRENT_SESSIONS=10"
dokku chrome:create lolipop

# Get connection information as follows
dokku chrome:info lolipop

# You can also retrieve a specific piece of service info via flags
dokku chrome:info lolipop --config-dir
dokku chrome:info lolipop --data-dir
dokku chrome:info lolipop --dsn
dokku chrome:info lolipop --exposed-ports
dokku chrome:info lolipop --id
dokku chrome:info lolipop --internal-ip
dokku chrome:info lolipop --links
dokku chrome:info lolipop --service-root
dokku chrome:info lolipop --status
dokku chrome:info lolipop --version

# A bash prompt can be opened against a running service
# filesystem changes will not be saved to disk
dokku chrome:enter lolipop

# You may also run a command directly against the service
# filesystem changes will not be saved to disk
dokku chrome:enter lolipop ls -lah /

# A chrome service can be linked to a
# container this will use native docker
# links via the docker-options plugin
# here we link it to our 'playground' app
# NOTE: this will restart your app
dokku chrome:link lolipop playground

# The following environment variables will be set automatically by docker (not
# on the app itself, so they won’t be listed when calling dokku config)
#
#   DOKKU_CHROME_LOLIPOP_NAME=/random_name/CHROME
#   DOKKU_CHROME_LOLIPOP_PORT=tcp://172.17.0.1:3000
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP=tcp://172.17.0.1:3000
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP_PROTO=tcp
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP_PORT=3000
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP_ADDR=172.17.0.1
#
# and the following will be set on the linked application by default
#
#   CHROME_URL=http://dokku-chrome-lolipop:3000
#
# NOTE: the host exposed here only works internally in docker containers. If
# you want your container to be reachable from outside, you should use `expose`.

# Another service can be linked to your app
dokku chrome:link other_service playground

# Since CHROME_URL is already in use, another environment variable will be
# generated automatically
#
#   DOKKU_CHROME_BLUE_URL=http://dokku-chrome-other-service:3000

# You can then promote the new service to be the primary one
# NOTE: this will restart your app
dokku chrome:promote other_service playground

# This will replace CHROME_URL with the url from other_service and generate
# another environment variable to hold the previous value if necessary.
# you could end up with the following for example:
#
#   CHROME_URL=http://dokku-chrome-other-service:3000
#   DOKKU_CHROME_BLUE_URL=http://dokku-chrome-other-service:3000
#   DOKKU_CHROME_SILVER_URL=http://dokku-chrome-lolipop:3000

# You can also unlink a chrome service
# NOTE: this will restart your app and unset related environment variables
dokku chrome:unlink lolipop playground

# You can tail logs for a particular service
dokku chrome:logs lolipop
dokku chrome:logs lolipop -t # to tail

# Finally, you can destroy the container
dokku chrome:destroy lolipop
```

## Disabling `docker pull` calls

If you wish to disable the `docker pull` calls that the plugin triggers, you may set the `CHROME_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker pull` is disabled.


## Thanks

This plugin was extensively based on the official storage plugins for dokku (e.g. https://github.com/dokku/dokku-postgres) -- thanks to the authors of those plugins for all their hard work!
