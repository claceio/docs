---
title: "Overview"
description: "Securely develop and deploy internal web applications"
weight: 100
---

The Clace server picks up its configuration from the config file specified at startup.

```bash
$ clace server start -h
NAME:
   clace server start - Start the clace server

USAGE:
   clace server start [command options] [arguments...]

OPTIONS:
   --server_url value, -s value      The server connection url (default: "http://127.0.0.1:25223") [$CL_SERVER_URL]
   --admin_user value, -u value      The admin user name (default: "admin") [$CL_ADMIN_USER]
   --admin_password value, -w value  The admin user password [$CL_ADMIN_PASSWORD]
   --http.host value, -i value       The interface to bind on for HTTP (default: "127.0.0.1") [$CL_HTTP_HOST]
   --http.port value, -p value       The port to listen on for HTTP (default: 25223) [$CL_HTTP_PORT]
   --https.host value                The interface to bind on for HTTPS (default: "0.0.0.0") [$CL_HTTPS_HOST]
   --https.port value                The port to listen on for HTTPS (default: 25224) [$CL_HTTPS_PORT]
   --logging.level value, -l value   The logging level to use (default: "INFO") [$CL_LOGGING_LEVEL]
   --logging.console, -c             Enable console logging (default: false) [$CL_LOGGING_CONSOLE]
   --help, -h                        show help

GLOBAL OPTIONS:
   --config_file value, -c value  TOML configuration file [$CL_CONFIG_FILE]
   --help, -h                     show help
```

All the parameters have default values, specified in the code at [clace.default.toml](https://github.com/claceio/clace/blob/main/internal/utils/clace.default.toml).

A user-specified config file is required. The location of this file can be set using the command line arg `--config_file`. If CLI arg is not specified, the environment variable `CL_CONFIG_FILE` is used to locate the config file. There is no default location for this file, if no CLI argument and env value are specified, then no configuration file is loaded.

All arguments are read from the user specified configuration file. Some arguments are further configurable in the CLI or env. For example, set `--http.host=7777` or env `CL_HTTP_PORT` to set the http port. The precedence order, from highest priority to lowest is:
* CLI argument
* ENV variable
* User specified config
* Default config in the source code for the Clace build version

## Home Directory

The `CL_HOME` environment variable used to locate the home directory for the Clace server. If no value is set, this defaults to the directory from which the Clace server was started. This location is used to store:
* The sqlite database containing the metadata information, default is `$CL_HOME/clace.db`
* The logs for the service, under the logs folder.
* The config folder contains the certificates to be use for TLS.
* The run folder contains app specific temporary files.
