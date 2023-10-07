---
title: "Security"
weight: 300
date: 2023-10-05
summary: "Clace Security related configuration"
---

The default configuration for the Clace server is:

- Application management (admin APIs) are accessible locally only, using unix domain sockets
- An admin user account is used to access applications
- The admin user password has to be added to the server config file, or a random password is generated every time the server is restarted
- Applications can be change not require any authentication
- There is no user management support in Clace currently, the plan is to integrate with OAuth2 providers and SAML services for managing user access

## Admin Account Password

When the Clace server is started, it looks for the entry

```toml
[security]
admin_password_bcrypt = "" # the password bcrypt value
```

in the config file. If the value is undefined or empty, then a random password is generated and is used as the admin password for that server session. The password being used is displayed on the stdout of the server startup. This will change on every restart.

To configure a fixed value for the admin user password, use the helper command

```bash
clace password
```

To generate a random password. This will print out the password and its bcrypt value to the screen. Save the password in your password manager and add the bcrypt has to your config file.

To use a particular value for the admin password, run

```bash
clace password --prompt
```

This will prompt for the password and print out the bcrypt hash to add to the config file.

## Admin API Access

By default, the Clace client uses Unix domain sockets to connect to the Clace server. Admin API calls to manage applications are disabled over HTTP/HTTPS by default. Unix sockets work when the client is on the same machine as the server, the client does not need to pass any credentials to connect over unix sockets. See [here]({{< ref "security#admin_api_access" >}}) for details about the client configuration.

To enable remote API calls, where the client is on a different machine from the server, the server needs to be changed to add the following:

```toml
[security]
admin_over_tcp = true
```

If running the Clace client from a remote machine, the config options required for the client are:

```toml
server_uri = "https://<SERVER_HOST>:25223"
admin_user = "admin"

[client]
admin_password = "" # Change to actual password
skip_cert_check = false # Change to true if using self-signed certs
```

These can be specified in a client config file or can be set in the CLI command line. All other config entries are ignored by the Clace client. Note that to connect to a Clace server over HTTP remotely, the server needs to be bound to the all interface(0.0.0.0), see [here]({{< ref "networking" >}}).

If server_uri is set to the https endpoint and the Clace server is running with a self-signed certificate, set `skip_cert_check = true` in config or pass `--skip_cert_check=true` in client commands to disable the TLS certificate check.

## Application Security

See [appsecurity]({{< ref "appsecurity" >}}) for details about the application level sandboxing.
