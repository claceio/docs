---
title: "Introducing Clace"
summary: "Introducing the Clace project: A Platform for Secure Internal Web Applications"
date: 2023-11-01
draft: true
---

# Clace: A Platform for Secure Internal Web Applications

Clace is an open-source platform to enable the creation and deployment of secure internal web applications. Clace aims to avoid ongoing maintenance challenges by avoiding build steps and having no external dependencies. Clace also provides flexible deployment options for individual or team use​.

Clace implements an application server in Go and uses Starlark (a dialect of Python) for application configuration. The applications can call out to plugins implemented in Go. The plugin boundary (Starlark to Go) allows the specification of sandboxing rules which are enforced by the platform. As long as the application stays within the original rules, further application updates can be done without requiring any admin approval.

<h2>How does it work?</h2>
Clace allows applications to be configured in <a href="https://github.com/google/starlark-go">Starlark</a> (subset of Python syntax). The API routes are defined to be Hypermedia first, using HTML templates to drive the UI interactions. Templates are written using Go HTML templates. HTMX is used for server interactions. The backend code runs in a security sandbox and access to plugins need to be explicitly permitted.  There are no python or Javascript dependencies to install. No containers to create, no yaml files to manage. Application updates can be done with no build step required. Clace integrates with TailwindCSS/DaisyUI for styling and has <a href="https://esbuild.github.io/">esbuild</a> built-in for <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules">ESM</a> support.
<br>
