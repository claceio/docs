---
title: "App Management Overview"
weight: 50
date: 2024-03-03
summary: "Overview of managing Clace applications"
---

The various commands for managing Clace apps are

```shell
$ clace
NAME:
   clace - Clace client and server https://clace.io/

USAGE:
   clace [global options] command [command options] [arguments...]

COMMANDS:
   server    Manage the Clace server
   app       Manage Clace apps
   preview   Manage Clace preview apps
   account   Manage Clace accounts
   version   Manage app versions
   password  Generate a password bcrypt config entry
   help, h   Shows a list of commands or help for one command

$ clace app
NAME:
   clace app - Manage Clace apps

USAGE:
   clace app command [command options] [arguments...]

COMMANDS:
   create   Create a new app
   list     List apps
   delete   Delete an app
   approve  Approve app permissions
   reload   Reload the app source code
   promote  Promote the app from staging to production
   update   Update Clace apps settings
   help, h  Shows a list of commands or help for one command

```

The app management subcommands are under the `app` command. The `preview` command manages preview app for an app and `version` command manages versions for an app. The `account` command is for managing accounts for an app.

## App Management

All the app management subcommands except `create` take a glob pattern, so multiple apps can be updated using one command. Use the `--dry-run` option with any update CLI call to verify if the options specified are correct before the actual run. No database changes are committed during dry-run and no changes are done in memory.

## Glob Pattern

The `reload/delete/promote/approve/list/update` commands accept a glob pattern. `example.com:**` will match apps under the example.com domain. `*:**` will match all apps in all domains, `all` is a shortcut for this. When using glob patterns, place the pattern inside double-quotes to avoid issues with shell star expansion. For example, `"example.com:**"`

The default for `app list` command is to list all apps. All other commands require an glob pattern to be specified explicitly.

When multiple apps are being updated, if any one app fails, the whole operation is rolled back. This allows for atomic updates across multiple applications.

## App Listing

Use the `app list` command to list apps. If the `--internal` option is used, then the internal staging and preview apps for each matched prod app are also listed.

```shell

$ clace app list
Id                                  Type  Version Auth GitInfo                        Domain:Path                                                  SourceUrl
app_prd_2d3kCRk43FOuIGy979NbBWakRMm PROD        3 NONE main:9ce5e1adfc28983f7894      memory.demo.clace.io:/                                       github.com/claceio/clace/examples/memory_usage/
app_prd_2d3kCZ28w6VIzoXMsT9yldwijxL PROD        3 NONE main:9ce5e1adfc28983f7894      cowbull.co:/                                                 github.com/claceio/clace/examples/cowbull
app_prd_2d3kCjmw8ldQ2LaOd0CLmWXDApq PROD        3 NONE main:9ce5e1adfc28983f7894      /                                                            github.com/claceio/clace/examples/demo
app_prd_2d3kKVvSsSgUHqtNGZaD95NuLK3 PROD        3 NONE main:9ce5e1adfc28983f7894      du.demo.clace.io:/                                           github.com/claceio/clace/examples/disk_usage/
app_prd_2d6KcZmNwHIB8cSzNCotqBHpeje PROD        5 NONE main:ed7545ae739dfe85140a      utils.demo.clace.io:/bookmarks                               github.com/claceio/apps/utils/bookmarks

$ clace app list -i
Id                                  Type  Version Auth GitInfo                        Domain:Path                                                  SourceUrl
app_prd_2d3kCRk43FOuIGy979NbBWakRMm PROD        3 NONE main:9ce5e1adfc28983f7894      memory.demo.clace.io:/                                       github.com/claceio/clace/examples/memory_usage/
app_stg_2d3kCRk43FOuIGy979NbBWakRMm STG         3 NONE main:9ce5e1adfc28983f7894      memory.demo.clace.io:/_cl_stage                              github.com/claceio/clace/examples/memory_usage/
app_prd_2d3kCZ28w6VIzoXMsT9yldwijxL PROD        3 NONE main:9ce5e1adfc28983f7894      cowbull.co:/                                                 github.com/claceio/clace/examples/cowbull
app_stg_2d3kCZ28w6VIzoXMsT9yldwijxL STG         3 NONE main:9ce5e1adfc28983f7894      cowbull.co:/_cl_stage                                        github.com/claceio/clace/examples/cowbull
app_prd_2d3kCjmw8ldQ2LaOd0CLmWXDApq PROD        3 NONE main:9ce5e1adfc28983f7894      /                                                            github.com/claceio/clace/examples/demo
app_stg_2d3kCjmw8ldQ2LaOd0CLmWXDApq STG         3 NONE main:9ce5e1adfc28983f7894      /_cl_stage                                                   github.com/claceio/clace/examples/demo
app_prd_2d3kKVvSsSgUHqtNGZaD95NuLK3 PROD        3 NONE main:9ce5e1adfc28983f7894      du.demo.clace.io:/                                           github.com/claceio/clace/examples/disk_usage/
app_stg_2d3kKVvSsSgUHqtNGZaD95NuLK3 STG         3 NONE main:9ce5e1adfc28983f7894      du.demo.clace.io:/_cl_stage                                  github.com/claceio/clace/examples/disk_usage/
app_prd_2d6KcZmNwHIB8cSzNCotqBHpeje PROD        5 NONE main:ed7545ae739dfe85140a      utils.demo.clace.io:/bookmarks                               github.com/claceio/apps/utils/bookmarks
app_stg_2d6KcZmNwHIB8cSzNCotqBHpeje STG         5 NONE main:ed7545ae739dfe85140a      utils.demo.clace.io:/bookmarks_cl_stage                      github.com/claceio/apps/utils/bookmarks
```

Use the `app version` command to list versions for particular apps. This command works on prod app or staging app specifically.

```shell
$ clace version list utils.demo.clace.io:/bookmarks_cl_stage
Active  Version Previous CreateTime                     GitCommit            GitMessage
              1        0 2024-03-01 19:59:27 +0000 UTC  86385ff67deab288c362 Updated bookmarks app

              2        1 2024-03-01 20:00:20 +0000 UTC  86385ff67deab288c362 Updated bookmarks app

              3        2 2024-03-01 20:16:08 +0000 UTC  86385ff67deab288c362 Updated bookmarks app

              4        3 2024-03-02 00:12:28 +0000 UTC  8080fcfe6be832a1f6f5 Update styling for bookmarks app

=====>        5        4 2024-03-02 00:23:35 +0000 UTC  ed7545ae739dfe85140a Update styling for bookmarks app

$ clace version list utils.demo.clace.io:/bookmarks
Active  Version Previous CreateTime                     GitCommit            GitMessage
              1        0 2024-03-01 19:59:27 +0000 UTC  86385ff67deab288c362 Updated bookmarks app

              2        1 2024-03-01 20:00:20 +0000 UTC  86385ff67deab288c362 Updated bookmarks app

=====>        5        2 2024-03-02 00:23:35 +0000 UTC  ed7545ae739dfe85140a Update styling for bookmarks app
```

The `version switch` command can be used to switch versions, up or down or to particular version. The `version revert` command can be used to revert the last change. `app promote` makes the prod app run the same version as the current staging app.

In the above listing, the staging app has five versions. Three of those (1,2 and 5) were promoted to prod. `version switch previous utils.demo.clace.io:/bookmarks_cl_stage` will change the stage app to version 4. `version switch previous utils.demo.clace.io:/bookmarks` will change the prod app to version 2. After that, `app promote utils.demo.clace.io:/bookmarks` will change prod to also be at version 4, same as stage. The `switch` command takes `previous`, `next` and actual version number as arguments.

A star, like `PROD*` in the `app list` output indicates that there are staged changes waiting to be promoted. That will show up any time the prod app is at a different version than the stage app.

## App Authentication

By default, apps are created with the system authentication type. System auth uses `admin` as the username. The password is displayed on the screen during the initial setup of the Clace server config.

To change app to be un-authenticated, add `--auth none` to the `app create` command. After an app is created, the auth type can be changed by running `app update-settings auth none /myapp`. OAuth based authentication is also supported, see [authentication]({{< ref "docs/configuration/authentication" >}}) for details.

{{<callout type="warning" >}}
Changes done to the app settings using the `app update-settings` command are not staged or versioned, they apply immediately to the stage/prod/preview apps. App settings are fundamental properties of the app, like what authentication type to use, what git auth key to use etc.

All other changes done to app metadata (like account linking, permission approval and code reload) are staged before deployment. Use the `--promote` option on the change to promote the change immediately after applying it on the staging app. Use `app promote` command to promote later. When a promotion is done, **all** previously staged changes for that app are promoted, not just the most recent change.
{{</callout>}}
