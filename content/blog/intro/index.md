---
title: "Introducing Clace"
summary: "Introducing the Clace project: A Platform for Secure Internal Web Applications"
date: 2023-11-01
draft: false
---

# Clace: Platform for Secure Internal Web Applications

Clace is an [open-source](https://github.com/claceio/clace) platform to enable the creation and deployment of secure internal web applications. The goals for the Clace project are:

- Enable development and deployment of secure internal web applications.
- Simplify ongoing maintenance of such apps by removing build and dependency related issues. Updating an app after six months or six years should just work.
- Provide portable and flexible deployment options, allowing use on personal machine and also shared across teams.

## Use-cases

Clace is built to solve two different types of use-cases:

- Custom applications: With fully customizable UI, this would be similar to solutions like [Retool](https://retool.com/). A low-code approach is used, with a focus on [Hypermedia driven applications](https://hypermedia.systems/hypermedia-reintroduction/).
- Workflows: This would be similar to solutions like [Rundeck](https://www.rundeck.com/). A way to automate internal applications, with a form based interface, with support for triggered and scheduled execution.

One of the aims of Clace is to make it possible for everyone, especially backend engineers, to develop and use simple web interfaces. For use-cases where a CLI was developed previously, a Clace based UI could be built. The backend service could invoke the CLI command or directly call the internal API which need to be exposed. Development and use of simple web interfaces for all types of use-cases should be made easier with Clace.

## How does it work?

Clace applications are configured in [Starlark](https://github.com/google/starlark-go), which uses a subset of Python syntax. The API routes are defined to be Hypermedia first, using HTML templates to drive the UI interactions. Templates are written using Go HTML templates. [HTMX](https://htmx.org/) is used for server interactions. The backend code runs in a security sandbox and every access to plugins need to be explicitly permitted. Application updates can be done with no build step required. Clace integrates with TailwindCSS/DaisyUI for styling and has [esbuild](https://esbuild.github.io) built-in for [ESM](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) support.

## Security

The Starlark backend code for Clace runs in a sandbox, all external interactions need to go through plugins. The Clace platform implements a security sandbox at the plugin boundary. Applications define what operations they need to be able to perform. The platform enforces these permissions at runtime.

This [security model]({{< ref "appsecurity" >}}) enables the following:

- Users can download applications and run on their machine, without worrying about what operations the app can do on their system outside the audited permissions.
- Operations teams can install and approve applications. Further application updates can be handled by the development team, without requiring the operational admins to verify the updated code. As long as the application works within the originally defined permission boundary, application updates will continue to work.
- Application developers can use LLM powered automated code generation tools without worrying about the side-effects of the code. If the generated code tries to perform any operation not previously approved, it will fail.

The sandbox will ensure that the apps can do only authorized operations. This makes Clace an ideal target for LLM (like GPT) generated applications. The Clace platform will add the authentication/authorization, gitops based deployment and operational monitoring features on top of the generated app.

## Current Status

Clace is in a beta state currently. Custom application support is functional. Support for loading plugins dynamically is in progress. You can try out Clace (on OSX, Linux or Windows with WSL) by doing:

```shell
curl -L https://clace.io/install.sh | sh
source $HOME/clhome/bin/clace.env
clace server start &
clace app create --approve /disk_usage github.com/claceio/clace/examples/disk_usage/
```

The app should be available at [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) after allowing the self-signed certificate. `admin` is the username, use the password printed by the install script. See [installation]({{< ref "installation" >}}) for details.

## Follow Along

You can keep in touch by these means:

- Star the repo on [GitHub](https://github.com/claceio/clace)
- Sign up for [Email updates](https://clace.io/)
- Follow on [Twitter](https://twitter.com/claceio)
- RSS feed at [Clace blog](https://clace.io/blog/index.xml)
- Follow on [LinkedIn](https://www.linkedin.com/company/claceio)
