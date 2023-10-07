---
title: "Overview"
weight: 100
date: 2023-10-05
summary: "Overview of Clace configuration, at the server level and client level and the $CL_HOME location for files"
---

## Clace Server

The Clace server picks up its configuration from the config file specified at startup.

```bash
$ clace server start -h
NAME:
   clace server start - Start the clace server

USAGE:
   clace server start [command options] [arguments...]

OPTIONS:
   --server_uri value, -s value     The server connection uri (default: "$CL_HOME/run/clace.sock") [$CL_SERVER_URI]
   --admin_user value, -u value     The admin user name (default: "admin") [$CL_ADMIN_USER]
   --http.host value, -i value      The interface to bind on for HTTP (default: "127.0.0.1") [$CL_HTTP_HOST]
   --http.port value, -p value      The port to listen on for HTTP (default: 25222) [$CL_HTTP_PORT]
   --https.host value               The interface to bind on for HTTPS (default: "0.0.0.0") [$CL_HTTPS_HOST]
   --https.port value               The port to listen on for HTTPS (default: 25223) [$CL_HTTPS_PORT]
   --logging.level value, -l value  The logging level to use (default: "INFO") [$CL_LOGGING_LEVEL]
   --logging.console, -c            Enable console logging (default: false) [$CL_LOGGING_CONSOLE]
   --help, -h                       show help

GLOBAL OPTIONS:
   --config_file value, -c value  TOML configuration file [$CL_CONFIG_FILE]
   --help, -h                     show help
```

All the parameters have default values, specified in the code at [clace.default.toml](https://github.com/claceio/clace/blob/main/internal/utils/clace.default.toml).

A user-specified config file is required. The location of this file can be set using the command line arg `--config_file`. If CLI arg is not specified, the environment variable `CL_CONFIG_FILE` is used to locate the config file. There is no default location for this file, if no CLI argument and env value are specified, then no configuration file is loaded.

All arguments are read from the user specified configuration file. Some arguments are further configurable in the CLI or env. For example, set `--http.host=7777` or env `CL_HTTP_PORT` to set the http port. The precedence order, from highest priority to lowest is:

- CLI argument
- ENV variable
- User specified config
- Default config in the source code for the Clace build version

## Home Directory

The `CL_HOME` environment variable is used to locate the home directory for the Clace server. If no value is set, this defaults to the directory from which the Clace server was started. This location is used to store:

- The sqlite database containing the metadata information, default is `$CL_HOME/clace.db`
- The logs for the service, under the logs folder.
- The config folder contains the certificates to be use for TLS.
- The run folder contains app specific temporary files.

## Clace Client CLI

By default, the Clace client uses Unix domain sockets to connect to the Clace server. The `$CL_HOME` should point to the same location for server and client. If no changes are done for the server defaults, then the client can connect to the server locally without any other configuration being required. See [here]({{< ref "security#admin-api-access" >}}) for details about the client configuration.
