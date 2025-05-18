---
title: "Introducing Clace"
summary: "Clace: Platform for managing internal tools"
date: 2023-11-01
draft: false
---

{{< clace-intro  >}}

# Clace: Platform for Managing Internal Tools

Clace is an [open-source](https://github.com/claceio/clace) platform to enable easy development and deployment of web applications for internal tools. The goals for the Clace project are:

- Enable development and deployment of secure internal web applications.
- Simplify ongoing maintenance of such apps by removing build and dependency related issues. Updating an app after six months or six years should just work.
- Provide portable and flexible deployment options, easy to use on developer machines and also on a shared server across teams.

## Use-cases

Clace is built to solve two different types of use-cases:

- Custom applications: With fully customizable UI, this would be similar to solutions like [Retool](https://retool.com/). A low-code approach is used, with a focus on [Hypermedia driven applications](https://hypermedia.systems/hypermedia-reintroduction/).
- Actions: This would be similar to solutions like [Rundeck](https://www.rundeck.com/). A way to automate internal applications, with a form based interface, with support for triggered and scheduled execution.

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
curl -sSL https://clace.io/install.sh | sh
```

Start a new terminal (to get the updated env) and run `clace server start` to start the Clace service.

To install apps declaratively, run

```
clace apply --approve github.com/claceio/clace/examples/utils.star all
```

Open https://localhost:25223 to see app listing. See [installation]({{< ref "installation" >}}) for details.

## Follow Along

You can keep in touch by these means:

- Star the repo at [github.com/claceio/clace](https://github.com/claceio/clace)
- Sign up for [Email updates](https://clace.io/#:~:text=Sign%20up%20for%20email%20updates)
- Follow on [Twitter](https://twitter.com/akclace)
- Subscribe to the blog [RSS feed](https://clace.io/blog/index.xml)
- Follow ClaceIO on [LinkedIn](https://www.linkedin.com/company/claceio)
- Connect on [Discord](https://discord.gg/t2P8pJFsd7)

Use [discussions](https://github.com/claceio/clace/discussions) feature in Github or raise [issues](https://github.com/claceio/clace/issues) to provide feedback.
