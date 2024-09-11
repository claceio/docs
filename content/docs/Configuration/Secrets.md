---
title: "Secrets Management"
weight: 500
summary: "Details about working with secret managers"
---

Clace supports secret management when working with apps. Secrets can be passed to containerized apps through the environment params. Secrets can also be passed to any plugin as argument. For OAuth config, the client secrets can be configured as secret in the config file.

## Supported Providers

Clace current supports AWS Secrets Manager (ASM) and HashiCorp Vault as providers for secrets management. Secrets can also be read from the environment of the Clace server, which can be used in development and testing.

## AWS Secrets Manager

To enable ASM, add one or more entries in the `clace.toml` config. The config name should be `asm` or should start with `asm_`. For example

```toml {filename="clace.toml"}
[secret.asm]

[secret.asm_prod]
profile = "myaccount"

```

creates two ASM configs. `asm` uses the default profile and `asm_prod` uses the `myaccount` profile. The default config is read from the home directory ~/.aws/config and ~/.aws/credentials as documented in [AWS docs](https://docs.aws.amazon.com/sdkref/latest/guide/file-location.html). The user id under which the Clace server was started is looked up for the aws config file.

To access a secret in app parameters from `asm_prod` config, use `--param MYPARAM='{{secret "asm_prod" "MY_SECRET_KEY"}}'` as the param value.

## HashiCorp Vault

To enable Vault secret provider, add one or more entries in the `clace.toml` config. The config name should be `vault` or should start with `vault_`. For example

```toml {filename="clace.toml"}
[secret.vault_local]
address = "http://127.0.0.1:8200"
token = "abc"

[secret.vault_prod]
address = "http://myvault.example.com:8200"
token = "def"
```

creates two Vault configs. The `address` and `token` properties are required.

## Environment Secrets

Adding a secret provider with the name `env`, like

```toml {filename="clace.toml"}
[secret.env]
```

enables looking up the Clace server environment for secrets. This can be accessed like `--param MYPARAM='{{secret "env" "MY_SECRET_KEY"}}'`. No properties are required in the env provider config. The vaule of MY_SECRET_KEY in the Clace server env wil be passed as the param.

## Secrets Usage

Secrets can be accessed using the syntax `{{secret "PROVIDER_NAME" "KEY_NAME"}}`. The three contexts in which secrets can be accessed are:

- **App Params** : Param values in `params.star` or in the [app metadata definition]({{< ref "/docs/container/overview/#app-environment-params" >}}) can access the secrets.
- **Plugin arguments** : Secrets can be passed as string arguments in calls to [plugin functions]({{< ref "plugins" >}}).
- **Config file**: Secrets are supported in `clace.toml` config for:
  - For client key and secret in [auth config]({{< ref "/docs/configuration/authentication/#oauth-authentication" >}})
  - For password in [git_auth config]({{< ref "/docs/configuration/security/#private-repository-access" >}})
  - For string values in [plugin config]({{< ref "/docs/plugins/overview/#account-linking" >}})

Secrets are always resolved late. The Starlark code does not get access to the plain text secrets. The secret lookup happens when the call to the plugin API is done. In case of params, the lookup happens when the param is passed to the container.

For git_auth config, an example secret usage is

```toml {filename="clace.toml"}
[auth.google_prod]
key = "mykey.apps.googleusercontent.com"
secret = '{{secret "PROVIDER_NAME" "GOOGLE_OAUTH_SECRET"}}'
hosted_domain = "example.com"
```
