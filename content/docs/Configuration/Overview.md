---
title: "Config Overview"
weight: 100
date: 2023-10-05
summary: "Overview of Clace configuration, at the server level and client level and the $CL_HOME location for files"
---

## Clace Server

The Clace server picks up its configuration from the config file at startup. All the parameters have default values, specified in the code at [clace.default.toml](https://github.com/claceio/clace/blob/main/internal/system/clace.default.toml).

A user-specified config file can be provided. The environment variable `CL_CONFIG_FILE` is used to locate the config file. If not set, it defaults to `$CL_HOME/clace.toml`.

Values in the user specified config take precedence over the default config values in the source code.

## Home Directory

The `CL_HOME` environment variable is used to locate the home directory for the Clace server. If no value is set, this defaults to the directory from which the Clace server was started. This location is used to store:

- The default config file, `$CL_HOME/clace.toml`
- The sqlite database containing the metadata information, default is `$CL_HOME/clace.db`
- The logs for the service, under the `logs` folder.
- The config folder contains the certificates to be use for TLS.
- The run folder contains app specific temporary files.

## Clace Client CLI

By default, the Clace client uses Unix domain sockets to connect to the Clace server. `$CL_HOME` should point to the same location for server and client. If no changes are done for the server defaults, then the client can connect to the server locally without any other configuration being required. See [here]({{< ref "security#admin-api-access" >}}) for details about the client configuration.
