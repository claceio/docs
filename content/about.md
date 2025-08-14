---
title: "About"
summary: "About OpenRun"
date: 2023-10-05
---

### What is OpenRun?

OpenRun is an Apache-2.0 licensed project building a web app development and deployment platform for internal tools. OpenRun allows easy and secure hosting of multiple web apps, in any language/framework, on a single machine. OpenRun is cross-platform (Linux/Windows/OSX) and provides a GitOps workflow for managing web apps.

### Project Goals

The goal of this project is to make it easy for individuals and teams to develop and manage lightweight full stack applications in a secure manner. OpenRun aims to make it easy to install and manage secure self-hosted web applications with minimal operational overhead. Easy integrations to enable SSO/SAML based authentication and authorization controls, audit logs and integration with secrets manager for managing credentials are goals.

A single developer should be able to manage the full application lifecycle: frontend and backend development and production deployment. Deployments should support a GitOps approach, with automatic preview environment to verify changes before making them live. It should be easy, for the original developer or a new one, to make application code changes and deploy - after six months or after six years.


### How is OpenRun implemented?

- Single binary web application server (in golang), with a set of plugins built in (also in golang) which allow access to external endpoints. The server is statically configured using a TOML file.
- Applications are configured using [Starlark](https://github.com/google/starlark-go), which is a subset of Python. Python is an ideal glue language, Starlark is used to configure the application backend logic
- Multiple applications can be dynamically installed, an embedded SQLite database is used to store application metadata (Postgres support is in the roadmap).
- For applications using the container plugin, OpenRun works with Docker or Podman using CLI to build and run the containers.
- Path based routing, each app identified by a unique path. Also, domain based routing, which allows multiple domains to point to the same OpenRun instance, with path based routing being done independently for each domain.
- Automatic TLS certificate management for each domain to simplify deployments.
- A sandboxing layer is implemented at the Starlark(python) to Golang boundary, allowing the implementation of security and access control policies. Go code is trusted, Starlark code is untrusted.
- For Starlark based apps, the application UI is implemented using Go HTML templates, with [HTMX](https://htmx.org/) for interactivity. Go templates support [context aware templating](https://pkg.go.dev/html/template#hdr-Contexts) which prevents encoding related security issues. They also work well with the HTML fragments required for HTMX.
- No need to install any additional components like Python or NodeJS/NPM on the host machine. Integration with [tailwindcss-cli](https://tailwindcss.com/blog/standalone-cli) is supported. [esbuild](https://esbuild.github.io/) (using the esbuild go library) is supported out of the box for importing ESM modules.

### Current Status

The current status is:

- Client and server (in a single binary) for service management and configuration.
- Support for application development with Starlark based configuration.
- Container management support with Docker and Podman
- Auto-idling of containers to reduce resource usage
- Go HTML template loading and caching for request processing.
- HTTP plugin for communicating with REST endpoints.
- Exec plugin for running system commands.
- Built in admin account for local development.
- Auto-sync (file system watcher) and Auto-reload using SSE (automatic UI refresh) for speeding up the application development cycle.
- Admin functionality using unix domain sockets for security.
- Application sandboxing checks to ensure only audited operations are allowed.
- Staged deployment support, preview app creations support.
- App data persistence to sqlite with managed tables.

### Who is behind this project?

The project was started by [Ajay Kidave](https://www.linkedin.com/in/ajayvk/). Ajay's background has been in database systems and enterprise integration tools. OpenRun was started to find ways to reduce the development and operational complexity in tooling for internal applications.

### How to stay in touch?

- Star the repo at [github.com/openrundev/openrun](https://github.com/openrundev/openrun)
- Email at [contact@clace.io](mailto:contact@clace.io)
- Follow on [Twitter](https://twitter.com/akclace)
- Subscribe to the blog [RSS feed](https://openrun.dev/blog/index.xml)
- Connect on [Discord](https://discord.gg/t2P8pJFsd7)
