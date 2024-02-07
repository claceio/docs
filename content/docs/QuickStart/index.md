---
title: "Quick Start"
weight: 50
summary: "Quick Start guide on using Clace"
date: 2024-02-03
---

This pages provide a overview of how to start with Clace and provides links to documentation pages with more details.

## Installation

To install the latest release build, run the install script on Linux, OSX and Windows with WSL. Note down the password printed. Add the env variables as prompted and then start the service.

```shell
curl -L https://clace.io/install.sh | sh
source $HOME/clhome/bin/clace.env
clace server start &
clace app create --approve /disk_usage github.com/claceio/app/system/disk_usage/
```

The app should be available at [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) after allowing the self-signed certificate. `admin` is the username and use the password printed by the install script.

See [installation]({{< ref "installation" >}}) for details. See [config options]({{< ref "configuration" >}}) for configuration options. To enable Let's Encrypt certificates, see [Automatic SSL]({{< ref "configuration/networking/#enable-automatic-signed-certificate" >}}).

On Windows without WSL, download the release binary zip from [releases](https://github.com/claceio/clace/releases) or [install from source]({{< ref "installation/#install-from-source" >}}) if you have go installed.

## Managing Applications

Multiple applications can be installed on a Clace server. Each app has a unique path and can be managed separately. The app path is made up of domain_name:url_path. If no domain_name is specified during app creation, the app is created in the default domain. The default domain is looked up when a specific domain match is not found. See [app routing]({{< ref "applications/routing/" >}}) for details about routing.

For local env, url based routing is easier, since wildcard DNS is not available by default for the localhost domain.
For production deployment, if wildcard DNS is setup, that makes domain routing easy, otherwise url based routing works for prod env also.

## App Installation

To install apps, run

```shell
clace app install --approve /disk_usage github.com/claceio/apps/system/disk_usage
```

This is installing the `system/disk_usage` app from the main branch of the `claceio/apps` repo on GitHub. The app is installed for the default domain, to the `/disk_usage` path. Opening [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) will cause Clace to initialize the app and show the app pages.

{{< alert >}}
The `/disk_usage/*` path is now reserved for API's under this app. No new apps can be installed under the `/disk_usage/` path, but `/disk_usage2` is available. Similarly, installing an app under `/` path means no new apps can be installed for the default domain.
{{< /alert >}}

If the app code is available locally, the `app install` can be done directly with that path:

```shell
clace app install --approve /disk_usage_local ./diskapp
```

When developing an app, the source code for the app has to be present locally. To install an app in dev mode, add the `--dev` option.

```shell
clace app install --dev --approve /disk_usage_dev ./diskapp
```

In dev mode, source code changes are picked up immediately and the app is automatically reloaded. For non-dev (prod) apps, `app reload` has to be done to pick up changes.

```
clace app reload --approve --promote "/disk_usage*"
```

For apps created from GitHub source, `app reload` will pick up the [latest changes]({{< ref "applications/lifecycle/#github-reload" >}}) from the branch specified during `app create` (default is `main`). For apps created from local disk sources, the reload loads from the same folder as originally used for the create. For prod mode apps, the source code is loaded into the SQLite metadata database managed by the Clace server.

## App Security

Application config is specified in Starlark code in the `app.star` file. By default, the app code does not have any permissions, all actions an app can perform are done through plugin API calls. Every plugin API call needs to [be approved]({{< ref "applications/appsecurity/#security-model" >}}) before it is allowed. This allows for multiple apps to run on the Clace server without interfering with each other.

To approve an app permissions, run

```shell
clace app approve /disk_usage
```

The `--approve` option can be specified during the `app create` and `app reload` command to automatically approve the permissions.

## App Lifecycle

For dev mode apps, there is just one app. For a prod mode app, creating the app initially creates a staging app and the actual production app. All config and code changes are applied on the [staging mode]({{< ref "applications/lifecycle/#staging-apps" >}}) app first, and then manually promoted using `app promote` or automatically, if `--promote` is specified for the `app reload`.

The `app list` command lists all the apps for the specified [glob pattern]({{< ref "applications/lifecycle/#glob-pattern" >}}). By default, it lists only the dev and prod apps. To list the staging apps also, add the `--internal` option to `app list`. `all` is a shortcut for `*:***`, which means all apps in all domains. For example

```shell
clace app list --internal all
```

lists all the apps and internal apps for each app. `clace app list "example.com:**"` list the main apps for the example.com domain.

The staging app can be used to verify whether changes are working before the production app is updated. The staging app is accessible by suffixing `_cl_stage` at the end of the prod app path. So for an app at `https://example.com/`, the staging url is `https://example.com/_cl_stage`. For an app at `/utils/app1`, the staging app url is `/utils/app1_cl_stage`.

To promote change from staging to prod, run:

```shell
clace app promote all
```

or `clace app promote "/disk_usage*"` to promote specific apps. Use the `--dry-run` option to verify changes before they are actually applied.
