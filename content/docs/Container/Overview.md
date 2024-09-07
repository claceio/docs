---
title: "Container Overview"
weight: 100
summary: "Overview of Clace containerized apps"
---

## Containerized App

Clace builds the image and manages the container lifecycle for containerized apps. It is also possible to specific an image to use.

## App Specs

Clace app specs are defined at https://github.com/claceio/appspecs. Most specs use containers, the `proxy` spec is an exception.

The `image` spec specifies the image to use. for example

```shell
clace app create --spec image --approve --param image=nginx --param port=80 - nginxapp.localhost:/
```

downloads the nginx image, starts it and proxies any request to `nginxapp.localhost` (on the Clace server port, 25223 default) to the nginx containers port 80. The container is started on the first API call, and it is stopped automatically when there are no API calls.

For all other specs, the `Containerfile` is defined in the spec. For example, for the `python-streamlit` spec, the Containerfile is [here](https://github.com/claceio/appspecs/blob/main/python-streamlit/Containerfile). Running

```shell
clace app create --spec python-streamlit --branch master --approve github.com/streamlit/streamlit-example /streamlit_app
```

will create an app at https://localhost:25223/streamlit_app. On the first API call to the app, the image is built from the defined spec and the container is started.

## App Config

The app needs to have a `Containerfile` (or `Dockerfile`) to define how the image is built. The app Starlark config is usually like:

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

<!-- prettier-ignore-end -->

which completely specifies the app. This is saying that the app is using the container plugin to configure the container and the proxy plugin to proxy all API calls (`/` route) to the container url. On the first API call to the app, Clace will build the image, start the container and proxy the API traffic to the appropriate port. No other configuration is required in Starlark. If the container spec does not define the port being exposed, then the container config needs to specify the port number to EXPOSE. The port number can be parameterized.
