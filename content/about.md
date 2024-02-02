---
title: "About Clace"
summary: "FAQ about Clace"
date: 2023-10-05
---

### What is Clace?

Clace is an open-source (Apache-2.0 Licensed) project building a platform to easily develop and deploy self-hosted web applications. Clace provides a web application server focused on securely running multiple applications on a single installation. Applications are full stack, with a backend which can talk to external endpoints, the frontend can be auto generated forms or fully customizable web applications.

### Project Goals

The goal of this project is to make it easy for individuals and teams to develop and manage lightweight full stack applications in a secure manner. Fully configurable and secure self-hosted web applications with minimal code is the goal. Easy integrations to enable SSO/SAML based authentication and authorization controls, audit logs and integration with secrets manager for managing credentials are goals.

A single developer should be able to manage the full application lifecycle, frontend and backend development, test automation and production deployment. Deployments should support a gitops like approach, with automatic preview environment to verify changes before making them live. It should be easy, for the original developer or a new developer, to make application code changes - after six months or after six years.

Clace aims to provide a developer friendly development environment, while providing a performant and scalable deployment platform which is operationally simple to manage.

### Terminology

- **Internal applications**: Web applications built or downloaded for use by an individual or teams. For users, this could be apps to manage their machine, like monitor disk usage across folders. For teams, apps could automate common operations like managing resource limits, provisioning accounts etc.
- **Sandboxing**: Sandboxing is a security mechanism to ensure that an application stays within the rules set by the admin. If an application is configured to perform GET requests, trying to do a POST request from the application will fail until the admin authorizes the application to perform POST requests. Sandboxing is different from containers/jails. Those allow you to control at the network layer. Sandboxing allow more fine grained controls at the application API layer. Sandboxing allows usecases like allow GET but not POST, allow access to one database table but not to others etc.

### What's with the name

The name Clace is a play on **C**ommand **L**ine **Ace**, since building an UI for command line applications was an initial target use-case. The name is pronounced like _Place_, with a _C_.

### Why is there a need for such a platform?

There are tools like Rundeck and Jenkins which allow automating operational scripts. These have very limited UI customizability. At the other extreme, SaaS services like Retool which focus on internal tools development allow developing a customizable UI using no-code generators. These speed up the initial development experience to some extent but at the cost of operational complexity. Ongoing maintenance and updates for such low-code applications does not work well with general software development lifecycle best practices. Most such tools use a heavy-weight single page application (SPA) based UI model.

Clace aims for a middle ground, aiming for easy self-hosting and operational simplicity while allowing fully customizable lightweight hypermedia driven applications, with a focus on security.

### How is Clace implemented?

The way Clace tries to achieve these goals are:

- Single binary web application server (in golang), with a set of plugins built in (also in golang) which allow access to external endpoints. The server is statically configured using a TOML file.
- Applications are configured using [Starlark](https://github.com/google/starlark-go), which is a subset of Python. Python is an ideal glue language, Starlark is used to configure the application backend logic
- Multiple applications can be dynamically installed, an embedded SQLite database is used to store application metadata (Postgres support is in the roadmap).
- Path based routing, each app identified by a unique path. Also, domain based routing, which allows multiple domains to point to the same Clace instance, with path based routing being done independently for each domain.
- Automatic TLS certificate management for each domain to simplify deployments.
- A sandboxing layer is implemented at the Starlark(python) to Golang boundary, allowing the implementation of security and access control policies. Go code is trusted, Starlark code is untrusted.
- The application UI is implemented using Go HTML templates, with [HTMX](https://htmx.org/) for interactivity. Go templates support [context aware templating](https://pkg.go.dev/html/template#hdr-Contexts) which prevents encoding related security issues. They also work well with the HTML fragments required for HTMX.
- No need to install any additional components like Python or NodeJS/NPM. Integration with [tailwindcss-cli](https://tailwindcss.com/blog/standalone-cli) is supported. [esbuild](https://esbuild.github.io/) (using the esbuild go library) is supported out of the box for importing ESM modules.

### Current Status

The development of Clace was started in April 2023. The current status as of Jan 2024 is:

- Client and server (in a single binary) for service management and configuration.
- Initial support for application development with Starlark based configuration.
- Go HTML template loading and caching for request processing.
- HTTP plugin for communicating with REST endpoints.
- exec plugin for running system commands.
- Built in admin account for local development.
- Auto-sync (file system watcher) and Auto-reload using SSE (automatic UI refresh) for speeding up the application development cycle.
- Admin functionality using unix domain sockets for security.
- Application sandboxing checks to ensure only audited operations are allowed.
- Staged deployment support, preview app creations support.
- App data persistence to sqlite with managed tables.

The next steps are to finalize the application development interface, add support for loading eternal plugins, add support for SSO and RBAC etc.

### Who is behind this project?

The project was started by [Ajay Kidave](https://www.linkedin.com/in/ajayvk/). Ajay's background has been in database systems and enterprise integration tools. Clace was started to find ways to reduce the development and operational complexity in tooling for internal applications.

### What is the longer-term plan for Clace?

The current plan is to develop the open source project, with the aim of making Clace a great platform for managing internal applications. The service can currently scale up vertically, support for metadata storage in Postgres will be added which will enable horizontal scaling also.

For workload isolation and security reasons, some use cases might require a more distributed backend approach. An worker/agent mode is planned in the longer-term. This will mean the Clace server will not actually run the application code, the application code will run on distributed agents. Most regular use-cases should not require the agent mode; vertical and horizontal scaling should cover normal workloads. The core functionality of Clace, including SSO integration and all plugins, will remain Apache-2.0 licensed.
