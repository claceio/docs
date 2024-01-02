---
title: "Application Lifecycle"
weight: 200
date: 2024-01-01
summary: "Lifecycle for Clace applications, pushing changes live safely"
---

## Application Types

A Clace application can be one of four types:

- **Development Apps** : Used for developing apps, supports live reload from code change on disk.
- **Production Apps** : For production use. Can be created from git hosted source or from sources on local disk.
- **Staging Apps** : For reviewing code and config changes before they are pushed to prod. Every prod app has one staging app.
- **Preview Apps** : For creating a review environment for code changes, useful as part of code review.

## Development Apps

Development mode apps are used for developing or updating Clace apps. The source for these apps has to be on local disk, it cannot be git. Any code or config changes are live reloaded immediately for dev apps. To create a dev mode app, add the `--dev` option to the `app create` command. For example,

```sh
clace app create --dev --approve /myapp /home/user/mycode
```

## Production Apps

Without the `--dev` options, apps are created as production apps by default. Production apps can be created from source on GitHub or from local disk. In either case, the source code for the app is uploaded to the Clace metadata database. After app creation, the original source location is not read, until a `app reload` operation is performance to update the sources. For example:

```sh
clace app create --approve example.com:/ /home/user/mycode
```

creates an production app. After the app is created, the source folder `/home/user/mycode` can be deleted, since the sources are present in the Clace metadata database. Every production app automatically has one staging app associated with it.

## Staging Apps

Staging apps are created for each production app, in order to be able to verify config and code changes before they are made live. For example, after the previous `app create` command, a call to `app list` with the `--internal` option will show two apps:

```sh
clace app list --internal
Id                                  Type Version GitCommit                                GitBranch       Domain:Path                    SourceUrl
app_prd_2aMvX3fc9fH18n6i2Jew0tNxnky PROD 1                                                                example.com:/                  /home/user/mycode
app_stg_2aMvX3fc9fH18n6i2Jew0tNxnky STG  1                                                                example.com:/_cl_stage         /home/user/mycode

```

The second app is the staging app for the first. `app list` shows only the main apps by default, the `--internal` option makes it show the linked apps.

## Promoting Changes

When there are code change to make, running `app reload` will update the staging environment.

```sh
clace app reload example.com:/
Reloaded apps: example.com:/_cl_stage
1 app(s) reloaded, 0 app(s) approved, 0 app(s) promoted.
```

The staging app is version 2 now, prod app is still at version 1.

```sh
clace app list -i
Id                                  Type Version GitCommit                                GitBranch       Domain:Path                    SourceUrl
app_prd_2aMvX3fc9fH18n6i2Jew0tNxnky PROD 1                                                                example.com:/                  /home/user/mycode
app_stg_2aMvX3fc9fH18n6i2Jew0tNxnky STG  2                                                                example.com:/_cl_stage         /home/user/mycode
```

At this point, going to the url `example.com:/_cl_stage` will show the updated code. To promote the changes to prod, run `app promote`

```sh
clace app promote example.com:/
Promoting example.com:/
1 app(s) promoted.
```

The prod app shows at the same version as the staging app now

```sh
clace app list -i
Id                                  Type Version GitCommit                                GitBranch       Domain:Path                    SourceUrl
app_prd_2aMvX3fc9fH18n6i2Jew0tNxnky PROD 2                                                                example.com:/                  /home/user/mycode
app_stg_2aMvX3fc9fH18n6i2Jew0tNxnky STG  2                                                                example.com:/_cl_stage         /home/user/mycode
```

If the application code change requires new permissions, the reload operation will fail unless `--approve` is added.

To do the reload, approval and promotion is one step, do `clace app reload --approve --promote example.com:/`.

## GitHub Reload

The rules for fetching source code from local disk and GitHub are:

- If the source url starts with `http://`, `https://` or `github.com`, the source is assed to be from a github API endpoint. Otherwise the source is assumed to be local disk on the Clace server.
- If Clace client and server are on different machine and local disk is being used, the copy needs to be copied to the server node first.
- For GitHub source, the format is https://domain_name/org_name/repo_name/sub/folder, like `github.com/claceio/clace/examples/disk_usage`. The sub_folder should contain the `app.star` config file.
- During `app create` and `app reload`, the commit id takes precedence over the branch name if both are specified.
- During `app reload`, if no branch and commit are specified, then code is checked out from the current branch. `main` branch is used if no branch was previously specified. If a branch was previously specified, the code is checked out from that branch.

## Glob Pattern

The app reload/promote/approve/list commands accept a glob pattern. `example.com:**` will match apps under the example.com domain. `*:**` will match all apps in all domains, `all` is a shortcut for this. When using glob patterns, place the pattern inside double-quotes to avoid issues with shell star expansion. For example, `"example.com:**"`

The default for list command is to list all apps. All other command require an glob pattern to be specified explicitly.

When multiple apps are being updated, if any one app fails, the whole operation is rolled back. This allows for atomic updates across multiple applications.

## Preview Apps

Preview app allow the creation of any number of linked preview apps for a main app. This is supported only for apps created from GitHub source. A commit id needs to be specified. For example,

```sh
clace app preview /myapp 49182d4ca1cacbd8e3463a77c2174a6da1fb66c9
```

creates an app accessible at `/myapp_cl_preview_49182d4ca1cacbd8e3463a77c2174a6da1fb66c9` which runs the app code in the specified commit id.

Preview apps cannot be changed once they are created. If preview app requires new permissions, add the `--approve` option to the `app preview` command.

## Write Mode Access

Staging and Preview apps have read only access by default to plugin APIs. This means that when they make calls to plugin APIs, only APIs defined as READ by the plugin are permitted. The HTTP plugin defined GET/OPTIONS/HEAD requests as READ, POST/PUT/DELETE are defined as WRITE. For the CLI Exec plugin, the run API is defined as WRITE since the CLI command run might do write operations.

For cases where the plugin defines an API as Write, the app permission can overwrite the default type and define the operation to be a READ operation. For example, the disk_usage app runs the `du` command, which is a read operation. The [app config defines](https://github.com/claceio/clace/blob/49182d4ca1cacbd8e3463a77c2174a6da1fb66c9/examples/disk_usage/app.star#L45) the run plugin call as `type="READ"`, over-riding the default WRITE type defined in the plugin. If no type is specified in the permission, the type defined in the plugin takes effect.

Staging and Preview apps are allowed only READ calls by default, even if the app permissions allow WRITE operations. To allow stage apps access to WRITE operations, run `clace app update stage-write-access all true`. Change `all` to the desired app glob pattern.

To allow stage apps access to WRITE operation, run `clace app update preview-write-access example.com:/ true`. This changes the existing preview apps and any new preview apps created for example.com:/ to allow write operations, if the permissions have been approved.
