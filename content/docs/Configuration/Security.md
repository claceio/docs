---
title: "Security"
weight: 300
date: 2023-10-05
summary: "Clace Security related configuration"
---

The default configuration for the Clace server is:

- Application management (admin APIs) are accessible over unix domain sockets only (not accessible remotely). Since UDS enforces file permissions checks, no additional authentication is needed for admin APIs.
- Admin user account is used to access applications, default `auth` for apps is `system`
- The admin user password bcrypt hash has to be added to the server config file, or a random password is generated every time the server is restarted
- Applications can be changed to not require any authentication, `auth` can be `none` or use Oauth2 based auth.
- There is no user management support in Clace currently. The system account is present by default (which can be disabled) or OAuth based auth can be used.

## Admin Account Password

When the Clace server is started, it looks for the entry

```toml {filename="clace.toml"}
[security]
admin_password_bcrypt = "" # the password bcrypt value
```

in the config file. If the value is undefined or empty, then a random password is generated and is used as the admin password for that server session. The password being used is displayed on the stdout of the server startup. This will change on every restart.

To configure a value for the admin user password, use the `password` helper command:

```bash
clace password
```

to generate a random password. This will print out the password and its bcrypt value to the screen. Save the password in your password manager and add the bcrypt hash to your config file.

To use a particular value for the admin password, run:

```bash
clace password --prompt
```

This will prompt for the password and print out the bcrypt hash to add to the config file.

## Admin API Access

By default, the Clace client uses Unix domain sockets to connect to the Clace server. Admin API calls to manage applications are disabled over HTTP/HTTPS by default. Unix sockets work when the client is on the same machine as the server, the client does not need to pass any credentials to connect over unix sockets.

To enable remote API calls, where the client is on a different machine from the server, the server needs to be changed to add the following:

```toml {filename="clace.toml"}
[security]
admin_over_tcp = true
```

If running the Clace client from a remote machine, the config options required for the client are:

```toml {filename="clace.toml"}
server_uri = "https://<SERVER_HOST>:25223"
admin_user = "admin"

[client]
admin_password = "" # Change to actual password
skip_cert_check = false # Change to true if using self-signed certs
```

All other server related config entries are ignored by the Clace client. Note that to connect to a Clace server over HTTP remotely, the server needs to be bound to the all interface(0.0.0.0), see [here]({{< ref "networking" >}}).

If server_uri is set to the https endpoint and the Clace server is running with a self-signed certificate, set `skip_cert_check = true` in config to disable the TLS certificate check.

## Application Security

See [appsecurity]({{< ref "appsecurity" >}}) for details about the application level sandboxing.

## Private Repository Access

The `app create` and `app reload` commands can read public GitHub repositories. If the repository is private, to be able to access the repo, the [ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) needs to be specified. In the `clace.toml` config file, create an entry like:

```toml {filename="clace.toml"}
[git_auth.infoclace]
key_file_path = "/Users/myuser/.ssh/infoclace_rsa"
password = ""
```

`infoclace` is the git auth key name, `key_file_path` points to the location of a private key file for a user with access to the repository. When running `app create`, add the `--git-auth infoclace` option. The private key specified will be used for accessing the repository. `app reload` command will automatically use the same key as specified during the create.

To change the git auth key for an app, run:

```bash
clace app update-settings git-auth newkey /myapp
```
