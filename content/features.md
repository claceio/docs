---
title: "Features"
summary: "Features supported by Clace"
date: 2023-10-08
---

## Goals

The goals Clace is being built to support are:

- Enable development and deployment of secure internal web applications.
- Simplify ongoing maintenance of such apps by removing build and dependency related issues.
- Flexible deployment options, allowing use on personal machine and also shared across teams.

## App Development Features

The dev time features supported currently by Clace are:

- Hypermedia driven backend [API design]({{< ref "docs/app/routing" >}}), simplifying UI development.
- Live reload using SSE (Server Sent Events) with HTTP/2 for all application changes, backend and frontend.
- Automatic creation of ECMAScript modules using esbuild.
- Automatic download for JavaScript and CSS dependencies.
- Support for TailwindCSS and DaisyUI watcher integration.
- [Template caching]({{< ref "docs/app/templates/#template-file-location" >}}) and automatic reload on changes.

## App Deployment Features

The deployment features supported currently by Clace are:

- Backend app code runs in a [security sandbox]({{< ref "docs/applications/appsecurity/#security-model" >}}), with allowlist based permissions.
- [No build step]({{< ref "docs/app/overview/#app-lifecycle" >}}), the development artifacts are ready for production use.
- Zero downtime application updates.
- Scalable backend, all performance critical code is in Go, only application handler code is in Starlark.
- Support for domain based and path based [routing]({{< ref "docs/applications/routing/#request-routing" >}}) at the app level.
- Virtual filesystem with [content hash based file names]({{< ref "docs/app/templates/#static-function" >}}), enabling aggressive static content caching.
- [Automatic SSL]({{< ref "docs/configuration/networking/#enable-automatic-signed-certificate" >}}) certificate creation based on [certmagic](https://github.com/caddyserver/certmagic).

## Roadmap

Clace is early in its development. The feature roadmap for Clace is:

- Support for OAuth2 based login.
- Support for SSO with SAML.
- All plugins are internal (built into Clace binary) currently. The plan is to move to an external plugin model, plugins being loaded dynamically using [go-plugin](https://github.com/hashicorp/go-plugin).
- Support for github integration, apps being deployed from artifacts directly loaded from github.
- SQLite is used as the metadata storage currently. Support for postgres and other systems is planned.
- Preview mode for app updates, to check whether changes work before making them live.
- Support for workflow jobs, which would have a form based interface with limited customizability, but with support for triggered and scheduled execution.
- Support for application data persistance.
- UI interface for Clace admin operations.
- Record replay based automatic integration test creation. Record all responses at the plugin boundary and use that to replay integration test scenarios. This is speculative currently, depending on the how the external plugin model is implemented.
- Distributed agent model, where the Clace server does the initial routing but the actual application execution happens on remote worker nodes. This feature, when added, might use a different licensing model. This is also speculative currently.
