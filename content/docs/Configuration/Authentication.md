---
title: "App Authentication"
weight: 400
date: 2024-03-27
summary: "Details about authentication mechanisms for app access, including OAuth based auth"
---

By default, apps are created with the `none` authentication type. A `system` auth is available which uses `admin` as the username. The password is displayed on the screen during the initial setup of the OpenRun server config.

To set the auth type, add `--auth system` to the app create command. After an app is created, the auth type can be changed by running `app update-settings auth system /myapp`.

## Default Authentication Type

Any app when created uses the default auth type configured for the server. `none` is the default. To change this, add

```toml {filename="openrun.toml"}
[security]
app_default_auth_type = "github_prod"
```

assuming there is a `github_prod` oauth config.

Any new app created will use this as the auth unless overridden in the `app create` call or using `app update`.

## Client Cert Authentication (mTLS)

Apps can be updated to use mutual TLS authentication. To enable this, first set `disable_client_certs` to `false` in the `https` section. Add a `client_auth` config entry in server config with the CA certificate to verify against. Multiple entries can be added, the entry name should be `cert` or should start with `cert_`. For example

```toml {filename="openrun.toml"}
[https]
disable_client_certs = false

[client_auth.cert_test1]
ca_cert_file="/data/certs/ca1.crt"

[client_auth.cert_test2]
ca_cert_file="/data/certs/ca2.crt"
```

defines two client_auth configs: `cert_test1` using ca1.crt and `cert_test2` using ca2.crt. Apps can be updated to use this auth config by running `app update-settings auth cert_test1 /myapp` or `app update-settings auth cert_test2 /myapp`.

Any API call to the app has to pass the client certificates. Using curl, the call would look like:

```sh
curl -k --cert client.crt --key client.key https://localhost:25223/myapp
```

If the client cert has been signed with the root CA defined in /data/certs/ca1.crt, the API call will succeed. Otherwise it fails. HTTP requests are not allowed when client cert authentication is used.

## OAuth Authentication

OAuth based authentication is supported for the following providers:

- github
- google
- digitalocean
- bitbucket
- amazon
- azuread
- microsoftonline
- gitlab
- auth0
- okta
- oidc

The configuration format for each is

```toml {filename="openrun.toml"}
[auth.github_test]
key = "abcdefgh"
secret = "mysecret"
```

Here, the auth config entry name is `github_test`. The entry name can be one of the supported providers, or a supported provider name followed by a `_` and a qualifier. The provider name is case sensitive. So `github`, `google`, `github_prod`, `google_my_org` etc are valid config names. `github-test` and `my_org_google` are not valid.

The server `openrun.toml` can have multiple auth configs defined. One of them can be set to be the default using `app_default_auth_type` config. Apps can be configured to use one of `system` or `none` or a valid auth config name as the `auth`. For example, app 1 can use `system` and app 2 can use `github_test`.

## Callback Url

To enable any Oauth provider, the callback url domain has to be specified in the server config. Add

```toml {filename="openrun.toml"}
[security]
callback_url = "https://example.com:25223"
```

in the `openrun.toml`. In the OAuth account, for an entry `github_test`, the callback url to use will be `https://example.com:25223/_openrun/auth/github_test/callback`.

The format for the callback url to use is `<CALLBACK_URL>/_openrun/auth/<PROVIDER_ENTRY_NAME>/callback`. The callback url has to exactly match this format.

## OAuth Config Details

The config details depend on the provider type. The `key` is generally the Client Id and the `secret` is the Client Secret. For some providers, additional config config entries are supported. These are:

- **google**: The google provider supports a `hosted_domain` option. This is the domain name to verify on the user being logged in. For example, this can be set to `openrun.dev`.
- **okta**: The Okta provider supports the `org_url` config, the tenant url to verify.
- **auth0**: The Auth0 provider supports the `domain` config.
- **oidc**: OIDC supports the `discovery_url` config property.

For all the providers, an optional `scopes` property is also supported. This is the list of scopes to configure for the OAuth account.

{{<callout type="warning" >}}
The first time a new provider is added, it is important to manually verify an app, to verify if the required authentication restrictions are in place. For example, with google, any valid google user can login, including gmail.com accounts. The `hosted_domain` config has to be used to restrict this.
{{</callout>}}

The OAuth integration internally uses the [goth](https://github.com/markbates/goth) library, see [examples](https://github.com/markbates/goth/blob/master/examples/main.go) for implementation details.
