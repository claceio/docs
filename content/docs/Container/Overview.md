---
title: "Container Overview"
weight: 100
summary: "Overview of Clace containerized apps"
---

## Containerized App

A containerized app runs the backend APIs in a container. Clace builds the image and manages the container lifecycle. It is also possible to specific an image to use.

## App Specs

Clace app specs are defined at https://github.com/claceio/appspecs. Most specs use containers, the `proxy` spec is an exception.

## App Config

needs to have a `Containerfile` (or `Dockerfile`) to define how the image is built. The app definition can have

<!-- prettier-ignore -->
```html {filename="app.star"}
load("proxy.in", "proxy")
load("container.in", "container")

app = ace.app("My App",
              routes=[
                  ace.proxy("/", proxy.config(container.URL))
              ],
              container=container.config(container.AUTO),
              permissions=[
                  ace.permission("proxy.in", "config", [container.URL]),
                  ace.permission("container.in", "config", [container.AUTO])
              ]
       ) 
```

which completely specifies the app. This is saying that the app is using the container plugin to configure the container and the proxy plugin to proxy all API calls (`/` route) to the container url. On the first API call to the app, Clace will build the image, start the container and proxy the API traffic to the appropriate port. No other configuration is required in Starlark. If the container spec does not define the port being exposed, then the container config needs to specify the port number to use. The port number can be parameterized.

<!-- prettier-ignore-end -->
