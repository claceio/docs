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

Multiple applications can be installed on a Clace server. Each app has a unique path and can be managed separately. The app path is made up of domain_name:url_path. If no domain_name is specified during app creation, the app is created in the default domain. The default domain is looked up when no specific domain match is found. See [app routing]({{< ref "applications/routing/" >}}) for details about routing.

For local env, url based routing is easier, since wildcard DNS is not available by default for the localhost domain.
For production deployment, if wildcard DNS is setup, that makes domain routing easy. Apps can be hosted on multiple unrelated domains on one Clace server.

## App Installation

To install apps, run

```shell
clace app install --approve /disk_usage github.com/claceio/apps/system/disk_usage
```

This is installing the `system/disk_usage` app from the main branch of the `claceio/apps` repo on GitHub. The app is installed for the default domain, to the `/disk_usage` path. Opening [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) will make Clace initialize the app and show the app home page.

{{< alert >}}
The `/disk_usage/*` path is now reserved for API's under this app. No new apps can be installed under the `/disk_usage/` path, but `/disk_usage2` is available. Similarly, installing an app under `/` path means no new apps can be installed for the default domain.
{{< /alert >}}

If the app code is available locally on Clace server node, the `app install` can be done directly with the local disk path:

```shell
clace app install --approve /disk_usage_local ./diskapp
```

When developing an app, the source code for the app has to be present locally. To install an app in dev mode, add the `--dev` option.

```shell
clace app install --dev --approve /disk_usage_dev ./diskapp
```

In dev mode, source code changes are picked up immediately and the app is live reloaded. For non-dev (prod) apps, `app reload` has to be done to pick up changes, from local disk or from git.

```
clace app reload --approve --promote "/disk_usage*"
```

For apps created from GitHub source, `app reload` will pick up the [latest changes]({{< ref "applications/lifecycle/#github-reload" >}}) from the branch specified during `app create` (default is `main`). For apps created from local disk sources, the reload loads from the folder originally used during the create. For non-dev apps, the source code is loaded into the SQLite metadata database managed by the Clace server.

## App Security

Application config is specified in Starlark code in the `app.star` file. By default, the app does not have any permissions. All external actions an app can perform are done through plugin API calls. Every plugin API call needs to [be approved]({{< ref "applications/appsecurity/#security-model" >}}) before it is allowed. This allows for multiple apps to run on the Clace server without interfering with each other.

To approve an app permissions, run

```shell
clace app approve /disk_usage
```

The `--approve` option can be specified during the `app create` and `app reload` command to automatically approve the permissions.

## Staged Deployments

For dev mode apps, there is just one app. For a prod mode app, creating the app creates a staging app and the actual production app. All config and code changes are applied on the [staging mode]({{< ref "applications/lifecycle/#staging-apps" >}}) app first, and then manually promoted using `app promote` or automatically, if `--promote` option is specified for the `app reload`.

The `app list` command lists all the apps for the specified [glob pattern]({{< ref "applications/overview/#glob-pattern" >}}). By default, it lists only the dev and prod apps. To list the staging apps also, add the `--internal` option to `app list`. `all` is a shortcut for `*:**`, which means all apps in all domains. For example:

```shell
clace app list --internal all
```

lists all the apps and internal apps for each app. `clace app list "example.com:**"` lists the main apps for the example.com domain.

The staging app can be used to verify whether changes are working before the production app is updated. The staging app is accessible by suffixing `_cl_stage` at the end of the prod app path. So for an app at `https://example.com/`, the staging url is `https://example.com/_cl_stage`. For an app at `/utils/app1`, the staging app url is `/utils/app1_cl_stage`.

To promote changes from staging to prod, run:

```shell
clace app promote all
```

or `clace app promote "/disk_usage*"` to promote specific apps. Use the `--dry-run` option to verify changes before they are actually applied.

## Lifecycle without Git

If not using git, a workflow would be:

- Create a dev mode app, like `clace app create --dev --approve /myapp_dev ~/myappcode`
- Create a prod mode app, like `clace app create --approve /myapp ~/myappcode`
- As code changes are saved to disk, the changes are immediately live at `https://localhost:25223/myapp_dev`
- When code is in a stable state, run `clace app reload /myapp`. This will update the staging app with the most recent code from ` ~/myappcode` folder.
- The staging app is available at `https://localhost:25223/myapp_cl_stage` for verification.
- To promote the code to prod, run `clace app promote /myapp`. The staged code is promoted to prod, live at `https://localhost:25223/myapp`.

Having a staging environment helps catch issues related to account setup (which endpoint is pointed to etc) and other config issues before the changes are live on prod.

## Lifecycle With Git

If using git, a workflow would be:

- Create a dev mode app, like `clace app create --dev --approve /myapp_dev ~/myappcode`
- Create a prod mode app, like `clace app create --approve /myapp github.com/myorg/repo`
- As code changes are saved to disk, the changes are immediately live at `https://localhost:25223/myapp_dev`
- When code is in a stable state, check in the dev code to git.
- Run `clace app reload /myapp`. This will update the staging app with the most recent code from `main` branch in git.
- The staging app is live at `https://localhost:25223/myapp_cl_stage`. Verify the functionality of the staging app.
- To promote the code to prod, run `clace app promote /myapp`. The staged code is promoted to prod, live at `https://localhost:25223/myapp`.

## App Listing

Use `clace app list` to get list of installed app. By default, all apps are listed. Use a glob pattern like `example.com:**` to list specific apps. Pass the `--internal` or `-i` option to `list` to include the internal apps in the app listing. The pattern matches the main apps, and if the internal option is specified, the matched app's linked apps are also listed.

Use `clace version list` to get list of versions for an app. `clace version switch` allows switching between versions. The version command can be run separately on the staging app and prod app, like `clace version list /myapp_cl_stage` and `clace version list /myapp`. The current version is indicated in the output.

```shell
$ clace version list /dugit
Active  Version Previous CreateTime                     GitCommit            GitMessage
              1        0 2024-02-16 19:39:05 +0000 UTC  03ccaa35927667977646 Added version file listing support

              2        1 2024-02-16 19:55:51 +0000 UTC  03ccaa35927667977646 Added version file listing support

=====>        3        2 2024-02-16 21:18:16 +0000 UTC  c00d7b1e99712de13745 Added version switching support

$ clace version list /dugit_cl_stage
Active  Version Previous CreateTime                     GitCommit            GitMessage
              1        0 2024-02-16 19:39:05 +0000 UTC  03ccaa35927667977646 Added version file listing support

              2        1 2024-02-16 19:54:22 +0000 UTC  03ccaa35927667977646 Added version file listing support

              3        2 2024-02-16 20:38:44 +0000 UTC  c00d7b1e99712de13745 Added version switching support

=====>        4        3 2024-02-16 21:18:42 +0000 UTC  c00d7b1e99712de13745 Added version switching support

$ clace app list -i /dugit
Id                                  Type  Version Auth GitInfo                        Domain:Path                                                  SourceUrl
app_prd_2cSkPeHiATfH46pcUX8EdZqdWQb PROD*       3 SYST main:c00d7b1e99712de13745      /dugit                                                      github.com/claceio/clace/examples/disk_usage
app_stg_2cSkPeHiATfH46pcUX8EdZqdWQb STG         4 SYST main:c00d7b1e99712de13745      /dugit_cl_stage                                             github.com/claceio/clace/examples/disk_usage
```

In the above listing, the staging app is on version 4, prod app on version 3. The "\*" in the `app list` output indicates that the prod app has staged changes waiting to be promoted. Running `clace app promote /dugit` will update prod with the staged changes.

## Developing Apps

Clace apps are written using Starlark and Go HTML templates. Starlark is a subset of Python, it is easy to pick up even if you are not familiar with Python. Go HTML templates are used by tools like Hugo and Helm,
