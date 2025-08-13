---
title: "Config Overview"
weight: 100
date: 2023-10-05
summary: "Overview of OpenRun configuration, at the server level and client level and the $OPENRUN_HOME location for files"
---

## OpenRun Server

The OpenRun server picks up its configuration from the config file at startup. All the parameters have default values, specified in the code at [openrun.default.toml](https://github.com/openrundev/openrun/blob/main/internal/system/openrun.default.toml).

A user-specified config file can be provided. The environment variable `CL_CONFIG_FILE` is used to locate the config file. If not set, it defaults to `$OPENRUN_HOME/openrun.toml`.

Values in the user specified config take precedence over the default config values in the source code.

## Home Directory

The `OPENRUN_HOME` environment variable is used to locate the home directory for the OpenRun server. If no value is set, a home directory is determined based on the path of the openrun binary (generally one level above the bin directory where the binary is). This location is used to store:

- The default config file, `$OPENRUN_HOME/openrun.toml`
- The sqlite database containing the metadata information, default is `$OPENRUN_HOME/metadata/openrun.db`
- The logs for the service, under the `logs` folder.
- The config folder contains the certificates to use for TLS.
- The run folder contains app specific temporary files.

## OpenRun Client CLI

By default, the OpenRun client uses Unix domain sockets to connect to the OpenRun server. `$OPENRUN_HOME` should point to the same location for server and client. If no changes are done for the server defaults, then the client can connect to the server locally without any other configuration being required. See [here]({{< ref "security#admin-api-access" >}}) for details about the client configuration.

## App Config

In `openrun.toml`, properties which apply to all apps can be defined under the `[app_config]` section. For example

```toml {filename="openrun.toml"}
[app_config]
audit.redact_url = true
```

sets the redact property to true for all apps. The property can be further configured individually for one or more apps in the app metadata using

```sh
openrun app update-metadata conf --promote 'audit.redact_url=true' /myapp
```

## Config Access from Code

[App Params]({{< ref "docs/develop/#app-parameters" >}}) are the primary user configurable properties for apps. For cases where properties need to be read from `openrun.toml` config file or from env, the config builtin can be used. This is available as `config` in app definitions and in `params.star`. In app declaration (like `app.star`), this is available as `ace.config`.

The `config`/`ace.config` builtin supports the following parameters:

- **key** (string, required) : the config key name
- **default** (any, required) : the default value

`_branch` is a special key which resolves to the git branch from which the app declaration is loaded.

In `app.star`, a call to config like

```python {filename="app.star"}
system_list = ace.config("systems", ["local"])
```

will fetch the default value. Adding in `openrun.toml` config

```toml {filename="openrun.toml"}
[node_config]
systems = ["local", "stage", "test"]
```

will result in the configured value being available in the code. This allows for installation specific properties, while keeping the source code same across environments.

In app declaration, same can be accessed as

```python {filename="utils.star"}
system_list = config("systems", ["local"])
app("/utils/bookmarks", "github.com/openrundev/apps/utils/bookmarks", params={"systems"=systems_list})
```

If the app source code needs to be checked out from same branch as the app declaration, then do

```python {filename="apps.star"}
branch=config("_branch", "main")
app("/" + branch + "/bookmarks", "github.com/openrundev/apps/utils/bookmarks", git_branch=branch)
```

This creates the app from the same branch as used during the `apply`/`sync` command.
