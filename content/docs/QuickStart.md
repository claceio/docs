---
title: "Quick Start"
weight: 50
summary: "Quick Start guide on using Clace"
date: 2024-02-03
---

Clace is an Apache-2.0 licensed project building a web app development and deployment platform for internal tools. This page provides an overview of how to start with Clace and provides links to doc pages with more details.

## Installation

### Install On OSX/Linux

To install on OSX/Linux, run

```shell
curl -L https://clace.io/install.sh | sh
source $HOME/clhome/bin/clace.env
clace server start &
```

### Install On Windows

To install on Windows, run

```
pwsh -Command "iwr https://clace.io/install.ps1 -useb | iex"
```

Use `powershell` if `pwsh` is not available. Start a new command window (to get the updated env) and run
`clace server start` to start the Clace service.

### Install Apps

To install apps, run

```
clace app create --approve github.com/claceio/apps/system/list_files /files
clace app create --approve github.com/claceio/apps/system/disk_usage /disk_usage
clace app create --approve github.com/claceio/apps/utils/bookmarks /book
```

The disk usage app is available at https://localhost:25223/disk_usage (port 25222 for HTTP). admin is the username, use the password printed by the install script. The bookmark manager is available at https://localhost:25223/book, the list files app is available at https://localhost:25223/files. Add the `--auth none` flag to the `app create` command to disable authentication.

See [installation]({{< ref "installation" >}}) for details. See [config options]({{< ref "configuration" >}}) for configuration options. To enable Let's Encrypt certificates, see [Automatic SSL]({{< ref "configuration/networking/#enable-automatic-signed-certificate" >}}).

The release binaries are also available at [releases](https://github.com/claceio/clace/releases). See [install from source]({{< ref "installation/#install-from-source" >}}) to build from source.

## Application Types

Clace allows easy management of multiple apps on one Clace server installation. There are three main types of Clace apps:

- **Action apps** - App backend is defined in Starlark and an auto generated form UI and report is created by Clace. These are the simplest apps.
- **Containerized Apps** - App backend (in any language/framework) runs in a container. Clace acts as an application server doing reverse proxying for the app APIs. This allows Clace to install and manage apps built in frameworks like Streamlit/Gradio/FastHTML/FastAPI/Flask etc.
- **Hypermedia apps** - The app is completely customizable, allowing combining containerized apps with actions and custom API handlers, building Hypermedia driven UIs.

For all apps, Clace provides blue-green staged deployment, OAuth access controls, secrets management, TLS cert management etc.

## Action Apps

For use cases where an existing CLI application or API needs to be exposed as a web app, actions provide an easy solution. First, define the parameters to be exposed in the form UI. Create a `params.star` file with the params. For example,

```python {filename="params.star"}
param("dir", description="The directory to list files from", default="/tmp")
```

The app defines a run handler which runs `ls` on the specified directory. The output text is returned.

```python {filename="app.star"}
load ("exec.in", "exec")

def run(dry_run, args):
   out = exec.run("ls", ["-Lla"])
   if out.error:
       return ace.result(out.error)
   return ace.result("File listing for " + args.dir, out.value)

app = ace.app("List Files",
   actions=[ace.action("List Files", "/", run, description="Show the ls -a output for specified directory")],
   permissions=[
     ace.permission("exec.in", "run", ["ls"]),
   ],
)
```

The app, when accessed will look as shown below, with the `ls` command output displayed:

<picture  class="responsive-picture" style="display: block; margin-left: auto; margin-right: auto;">
  <source media="(prefers-color-scheme: dark)" srcset="/images/list_files_dark.png">
  <source media="(prefers-color-scheme: light)" srcset="/images/list_files_light.png">
  <img alt="List files app" src="/images/list_files_light.png">
</picture>

See [list_files](https://github.com/claceio/apps/tree/main/system/list_files) for the source code for above app. See [dictionary](https://github.com/claceio/apps/tree/main/misc/dictionary) for another actions example app which shows different type of reports. [Actions]({{< ref "actions" >}}) has more details on building app actions.

## Containerized Applications

Clace apps which are implemented in [Starlark](https://github.com/google/starlark-go) run within the Clace server. No containers are required for running those apps. For apps where the backend is implemented in any other language, containers are used to run the app. Clace works with Docker and Podman. By default, the server looks for the `podman` client CLI. If not found, it looks for the `docker` client CLI. To customize this, add in server config

```toml {filename="clace.toml"}
[system]
container_command = "/path/to/container_manager_cli"
```

There are two options for using containerized apps. One is to include the required files in the app repo. This will mean there should be `app.star` with the app config, a `Containerfile` or `Dockerfile` with the container config. The other option is to use an [app spec]({{< ref "app/overview/#building-apps-from-spec" >}}). This allows you to use Clace without requiring any changes to your app. No container file is even required. For example, the command

```
clace app create --spec python-streamlit --branch master --approve \
   github.com/streamlit/streamlit-example /streamlit
```

does the following:

- Checks out the `github.com/streamlit/streamlit-example`
- Copy any missing files from the app specification `python-streamlit` into the repo
- Load the app source and metadata into the Clace server metadata database (SQLite)

When the first API call is done to the app (lazy-loading), the Clace server will build the container image from the `Containerfile` defined in the spec, start the container and setup the proxy for the app APIs.

Any env params which need to be passed to the app can be configured as [app params]({{< ref "app/overview/#app-parameters" >}}). Params are set, during app creation using `app create --param port=9000` or after creation using `param update port 9000 /myapp`.

If the source repo has a `Containerfile` or `Dockerfile`, the `container` spec is a generic spec which works with any language or framework. If the container file defined a port using `EXPOSE` directive, then port is not required. Otherwise, specify a port, for example

```
clace app create --spec container --approve --param port=8000 \
     github.com/myorg/myrepo /myapp
```

See [containerized apps]({{< ref "container/overview/" >}}) for details.

## Managing Applications

Multiple applications can be installed on a Clace server. Each app has a unique path and can be managed separately. The app path is made up of domain_name:url_path. If no domain_name is specified during app creation, the app is created in the default domain. The default domain is looked up when no specific domain match is found. See [app routing]({{< ref "applications/routing/" >}}) for details about routing.

For local env, url based routing can be used or `*.localhost` domain can be used for domain based paths. For production deployment, if wildcard DNS is setup, domain based routing can be used without new DNS entries being required per app. Apps can be hosted on multiple unrelated domains on one Clace server.

## App Installation

To install apps, run `clace app create --approve <source_url> <[domain:]app_path>`. For example,

```shell
clace app create --approve github.com/claceio/apps/system/disk_usage /disk_usage
```

This is installing the `system/disk_usage` app from the main branch of the `claceio/apps` repo on GitHub. The app is installed for the default domain, to the `/disk_usage` path. Opening [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) will initialize the app and show the app home page.

{{<callout type="warning" >}}
The `/disk_usage/*` path is now reserved for API's under this app. No new apps can be installed under the `/disk_usage/` path, but `/disk_usage2` is available. Similarly, installing an app under `/` path means no new apps can be installed for the default domain.
{{</callout>}}

If the app code is available on the Clace server node, the `app create` can be done directly with the local disk path:

```shell
clace app create --approve ./diskapp /disk_usage_local
```

When developing an app, the source code for the app has to be present locally. To install an app in dev mode, add the `--dev` option.

```shell
clace app create --dev --approve ./diskapp /disk_usage_dev
```

In dev mode, source code changes are picked up immediately and the app is live reloaded. For non-dev (prod) apps, `app reload` has to be done to pick up changes, from local disk or from git.

```
clace app reload --approve --promote "/disk_usage*"
```

For apps created from GitHub source, `app reload` will pick up the [latest changes]({{< ref "applications/lifecycle/#github-reload" >}}) from the branch specified during `app create` (default is `main`). For apps created from local disk sources, the reload loads from the folder originally used during the create. For non-dev apps, the source code is loaded into the SQLite metadata database managed by the Clace server.This allow for versioning, even when working with local sources.

## App Security

Application config is specified in Starlark code in the `app.star` file. By default, the app does not have any permissions. All external actions an app can perform are done through plugin API calls. Every plugin API call needs to [be approved]({{< ref "applications/appsecurity/#security-model" >}}) before it is allowed. This allows for multiple apps to run on the Clace server without interfering with each other.

To approve an app permissions, run

```shell
clace app approve /disk_usage
```

The `--approve` option can be specified during the `app create` and `app reload` command to automatically approve the permissions.

## Staged Deployments

For dev mode apps, there is just one app. For a prod mode app, creating the app creates a staging app and the actual production app. All config and code changes are applied on the [staging mode]({{< ref "applications/lifecycle/#staging-apps" >}}) app first, and then manually promoted using `app promote`. Promotion is automatic if `--promote` option is specified for the `app reload` (or any other command performing a metadata change).

The `app list` command lists all the apps for the specified [glob pattern]({{< ref "applications/overview/#glob-pattern" >}}). By default, it lists only the dev and prod apps. To list the staging apps also, add the `--internal` (or `-i`) option to `app list`. `all` is a shortcut for `*:**`, which means all apps in all domains. `all` is the default for `app list`. For example:

```shell
clace app list --internal all
```

lists all the apps and internal apps for each app. `clace app list "example.com:**"` lists the main apps for the example.com domain.

The staging app can be used to verify whether changes are working before the production app is updated. The staging app is accessible by suffixing `_cl_stage` at the end of the prod app path. So for an app at `https://example.com/`, the staging url is `https://example.com/_cl_stage`. For an app at `/utils/app1`, the staging app url is `/utils/app1_cl_stage`.

To promote changes from staging to prod, run:

```shell
clace app promote all
```

or `clace app promote "/disk_usage*"` to promote specific apps. Use the `--dry-run` option to verify commands before they are actually applied.

## Lifecycle without Git

If not using git, a workflow would be:

- Create a dev mode app, like `clace app create --dev --approve ~/myappcode /myapp_dev`
- Create a prod mode app, like `clace app create --approve ~/myappcode /myapp`
- As code changes are saved to disk, the changes are immediately live at `https://localhost:25223/myapp_dev`
- When code is in a stable state, run `clace app reload /myapp`. This will update the staging app with the most recent code from ` ~/myappcode` folder.
- The staging app is available at `https://localhost:25223/myapp_cl_stage` for verification.
- To promote the code to prod, run `clace app promote /myapp`. The staged code is promoted to prod, live at `https://localhost:25223/myapp`.

Having a staging environment helps catch issues related to account setup (which endpoint is pointed to etc) and other config issues before the changes are live on prod. Clace implements versioning for prod apps, even when source is not from git.

## Lifecycle With Git

If using git, a workflow would be:

- Create a dev mode app, like `clace app create --dev --approve ~/myappcode /myapp_dev `
- Create a prod mode app, like `clace app create --approve github.com/myorg/repo /myapp `
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

In the above listing, the staging app is on version 4, prod app on version 3. The `*` in the `app list` output indicates that the prod app has staged changes waiting to be promoted. Running `clace app promote /dugit` will update prod with the staged changes. `version revert` reverts to previous version. `version switch` can be used to switch to particular version, `next` and `previous` are shortcuts for version numbers. Version commands run against the specific app, so revert can be done on the staging app or the main app independently.

## Developing Apps

Clace app backend can be written in any language, running in a container. Some apps can be written in [Starlark](https://github.com/google/starlark-go) and [Go HTML templates](https://pkg.go.dev/text/template), in which case no containers are required.

See [dev overview]({{< ref "app/overview/" >}}) for a quick start overview on developing Clace applications.
