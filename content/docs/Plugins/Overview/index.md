---
title: "Plugin Overview"
weight: 100
date: 2024-02-18
summary: "Overview of how plugins work, how to use them"
---

Plugins provide an API for Clace Starlark code to call out to external systems. Plugins are implemented in Go. Every plugin API calls needs to be in the approved list for it to be permitted. See [security]({{< ref "appsecurity#sample-application" >}}/) for an overview of the security model.

Each plugin is identified by a unique name, like `store.in` or `exec.in`. Plugins ending with `.in` are internal plugins, built into the Clace binary. Support for external plugins which are loaded dynamically is currently in progress.

## Plugin Usage

To use a plugin, load it using

```python
load("http.in", "http")
```

This adds `http` to the namespace for the app. To make a call to the plugin, first add the permissions to the app config.

```python
    permissions=[
        ace.permission("http.in", "get"),
        ace.permission("http.in", "post")
    ],
```

Run `clace app approve /myapp` to authorize the app to call the `get` and `post` methods on the http plugin.

In the app handler code, do

```python
    ret = http.get(SERVICE_URL + "/api/challenge/" + challenge_id)
    if not ret:
        return ace.response(ret.error, "invalid_challenge_id", code=404)
```

At runtime, Clace will check if the `get` call is authorized. If so, the call to the plugin will be performed.

## Response Handling

All plugin API calls return a `response` structure. The fields in this are

- `error` The error message string, empty string if no error
- `error_code` The error code integer, zero if no error
- `value` The actual return value for the plugin API call. The datatype for this depends on the API, check the API documentation for details.

The recommended pattern for handling the AIP response is

- Check boolean value for the return. If false, that indicates an error which can be returned.
- If no error, get the `value` property and continue with processing

For example,

```python
    ret = http.get("https://localhost:9999/test")
    if not ret:
        # error condition
        return ace.response(ret.error, "error_block")

    # success
    print(ret.value.json())
```

An alternate way to write the error check is

```python
    ret = http.get("https://localhost:9999/test")
    if ret.error:
        # error condition
        return ace.response(ret.error, "error_block")

    # Success
    print(ret.value.json())
```

## Plugin Accounts

Some plugins like `exec.in` do not require any account information. Others like `store.in` need some account information. The account configuration for a plugin is loaded from the Clace config file `clace.toml`. For example, the default configuration for `store.in` is [here](https://github.com/claceio/clace/blob/4cde3059e6a99abae20cebbddde5473149065fa9/internal/utils/clace.default.toml#L48), which contains:

```toml
[plugin."store.in"]
db_connection = "sqlite:$CL_HOME/clace_app.db?_journal_mode=WAL"
```

Any application using the `store.in` plugin will by default use the `$CL_HOME/clace_app.db` sqlite database. To change the default account config used by apps, update `clace.toml` and restart the Clace server. For example, adding the below will overwrite the default `store.in` config for all apps.

```toml
[plugin."store.in"]
db_connection = "sqlite:/tmp/clace_app.db?_journal_mode=WAL"
```

### Account Linking

If specific account config is required for an app, then the app can be linked to a specific account config. First add a new account config by adding in `clace.toml`

```toml
[plugin."store.in#tmpaccount"]
db_connection = "sqlite:/tmp/clace_app.db?_journal_mode=WAL"
```

For an app using `store.in`, run `clace account link --promote /myapp store.in tmpaccount`

This links the `myapp` app to use the `tmpaccount` account.

### Named Account

In addition to using account linking, the plugin code itself can point to specific accounts. For example, if the app code has

```python
load("http.in#google", "googlehttp")
```

then the app will use the `http.in#google` account config by default. This also can be overridden using account links, by
running `clace account link --promote /myapp http.in#google myaccount`

This approach is useful if an app has to access multiple accounts for the same plugin. The account linking approach is recommended for normal scenarios.

Clace apps aim to be portable across installations, without requiring code changes. Using account config allows the app code to be independent of the installation specific account config.
