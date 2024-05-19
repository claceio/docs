---
title: "About"
summary: "About Clace"
date: 2023-10-05
---

### What is Clace?

Clace is an Apache-2.0 licensed project building a web app development and deployment platform for internal tools. Clace allows easy and secure hosting of multiple web apps, in any language/framework, on a single machine. Clace is cross-platform (Linux/Windows/OSX) and provides a GitOps workflow for managing web apps.

### Project Goals

The goal of this project is to make it easy for individuals and teams to develop and manage lightweight full stack applications in a secure manner. Clace aims to make it easy to install and manage secure self-hosted web applications with minimal operational overhead. Easy integrations to enable SSO/SAML based authentication and authorization controls, audit logs and integration with secrets manager for managing credentials are goals.

A single developer should be able to manage the full application lifecycle, frontend and backend development, test automation and production deployment. Deployments should support a GitOps approach, with automatic preview environment to verify changes before making them live. It should be easy, for the original developer or a new developer, to make application code changes and them deploy easily - after six months or after six years.

Clace aims to provide a developer friendly development environment, while providing a performant and scalable deployment platform which is operationally simple to manage.

### Terminology

- **Internal applications**: Web applications built or downloaded for use by an individual or teams. For users, this could be apps to manage their machine, like monitor disk usage across folders. For teams, apps could automate common operations like managing resource limits, provisioning accounts etc.
- **Sandboxing**: Sandboxing is a security mechanism to ensure that an application stays within the rules set by the admin. If an application is configured to perform GET requests, trying to do a POST request from the application will fail until the admin authorizes the application to perform POST requests. Sandboxing is different from containers/jails. Those allow you to control at the network layer. Sandboxing allow more fine grained controls at the application API layer. Sandboxing allows usecases like allow GET but not POST, allow access to one database table but not to others etc. This applies for Starlark based apps. For container based apps, Clace plugin level sandboxing does not apply.

### What's with the name

The name Clace is a play on **C**ommand **L**ine **Ace**, since building an UI for command line applications was an initial target use-case. The name is pronounced like _Place_, with a _C_.

### Why is there a need for such a platform?

There are tools focussed on simplifying application deployment. Kamal, Dokku and Coolify simplify container management on server infrastructure. All those are Linux only tools, aiming to support production deployment of applications, managing the application layer and also the data persistence layer. Most use Traefik as the proxy, the labels added for containers are used to proxy the traffic. There are multiple components to understand when using these tools.

For internal tool deployment, easy of use is a primary consideration. Kubernetes is a platform to build platforms. Adding a GitOps workflow for Kubernetes requires additional tools like ArgoCD or Flux. For the use case of deploying webapps for internal tools, that level of complexity is generally overkill.

Clace aims to to be cross-platform (Linux, Windows and OSX). Clace supports app development in addition to production deployment. Clace is a single binary which includes the reverse proxy and container management functionality.

Only web app deployment is supported by Clace. Clace does not aim to support installing standalone databases or other infrastructure components. Web app containers can use an in-container database, that is supported by Clace. For internal tools, the data persistence is expected to be done externally, so this is not a issue generally.

### How is Clace implemented?

- Single binary web application server (in golang), with a set of plugins built in (also in golang) which allow access to external endpoints. The server is statically configured using a TOML file.
- Applications are configured using [Starlark](https://github.com/google/starlark-go), which is a subset of Python. Python is an ideal glue language, Starlark is used to configure the application backend logic
- Multiple applications can be dynamically installed, an embedded SQLite database is used to store application metadata (Postgres support is in the roadmap).
- For applications using the container plugin, Clace works with Docker or Podman using CLI to build and run the containers.
- Path based routing, each app identified by a unique path. Also, domain based routing, which allows multiple domains to point to the same Clace instance, with path based routing being done independently for each domain.
- Automatic TLS certificate management for each domain to simplify deployments.
- A sandboxing layer is implemented at the Starlark(python) to Golang boundary, allowing the implementation of security and access control policies. Go code is trusted, Starlark code is untrusted.
- For Starlark based apps, the application UI is implemented using Go HTML templates, with [HTMX](https://htmx.org/) for interactivity. Go templates support [context aware templating](https://pkg.go.dev/html/template#hdr-Contexts) which prevents encoding related security issues. They also work well with the HTML fragments required for HTMX.
- No need to install any additional components like Python or NodeJS/NPM on the host machine. Integration with [tailwindcss-cli](https://tailwindcss.com/blog/standalone-cli) is supported. [esbuild](https://esbuild.github.io/) (using the esbuild go library) is supported out of the box for importing ESM modules.

### Current Status

The development of Clace was started in April 2023. The current status as of May 2024 is:

- Client and server (in a single binary) for service management and configuration.
- Support for application development with Starlark based configuration.
- Container management support with Docker and Podman
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

The project was started by [Ajay Kidave](https://www.linkedin.com/in/ajayvk/). Ajay's background has been in database systems and enterprise integration tools. Clace was started to find ways to reduce the development and operational complexity in tooling for internal applications.

### What is the longer-term plan for Clace?

The current plan is to develop the open source project, with the aim of making Clace a great platform for managing internal applications. The service can currently scale up vertically. Support for metadata storage in Postgres will be added which will enable horizontal scaling. Integration with secrets managers is planned, to support passing secrets to Clace apps. RBAC mechanism is planned to support fine grained access control.
