---
title: "Container Config"
weight: 200
summary: "Overview of containerized app config and state management"
---

The default configuration for the OpenRun server is defined [here](https://github.com/openrundev/openrun/blob/main/internal/system/openrun.default.toml). The container related config settings are

```toml
[app_config]

# Health check Config
container.health_url = "/"
container.health_attempts_after_startup = 30
container.health_timeout_secs = 5

# Idle Shutdown Config
container.idle_shutdown_secs = 180
container.idle_shutdown_dev_apps = false

# Status check Config
container.status_check_interval_secs = 5
container.status_health_attempts = 3
```

A health check is done on the container after container is started. If the health check fails 30 times, the container is assumed to be down.

In the running state, a status check is done on the app every five seconds. If three of those checks fail, then the container is assumed to be down.

If an app does not receive any API request for 180 seconds, the app is assumed to be idle and the container is stopped. The idle shutdown does not apply for dev apps, only for prod mode apps.

## Changing Config

The `openrun.toml` can be updated to have a different value for any of the properties. After the server restart, the config change will apply for all apps.

To apply the config at the app level, the app metadata can be updated. For example the command

```sh
openrun app update-metadata conf --promote container.idle_shutdown_secs=600 /myapp
```

changes the idle timeout for the `/myapp` app to 600 secs. Without the `--promote` option, the change will be staged and can be verified on the staging app. App metadata level setting take precedence over the defaults in the `openrun.toml`. Using `all` as the app name will apply the change for all current apps (but not for any new apps created later).

## Docker/Podman

The default for the container command to use is

```toml
[system]
container_command = "auto"
```

`auto` means that OpenRun will look for `podman` in the path. If found, it will use that. Else it will use `docker` as the container manager command. If the value for `container_command` is set to any other value, that will be used as the command to use.

Orbstack implements the Docker CLI interface, so Orbstack also works fine with OpenRun.
