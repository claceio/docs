---
title: "Container Plugin"
weight: 400
summary: "Container plugin supports configuring container backend"
---

The `container.in` plugin provides the `config` API to allow configuring the container backend.

## Introduction

Clace can build and manage containers for implementing the app backend APIs. The `config` API is used to configure at the app level what configuration is used for the container.

## API

The `container.in` plugin has just one api, `config`

|    API     | Type |                    Notes                     |
| :--------: | :--: | :------------------------------------------: |
| **config** | Read | Configures the container details for the app |

The `config` API supports the following parameter:

- **src** (string, optional) : the source for containerfile, `auto` by default
- **port** (int, optional) : the port number exposed from the container
- **scheme** (string, optional) : the url scheme, `http` by default
- **health** (string, optional) : the health check API, `/` by default
- **lifetime** (string, optional) : the lifetime for the container, currently unused
- **build_dir** (string, optional) : the build directory for the build, `/` by default

When the `src` is auto, the container file is auto detected. It checks for presence of either `Containerfile` or `Dockerfile`. If the value begins with `image:`, the subsequent portion is treated as the image to download. No image build is done in that case. Any other value for `src` is treated as the file name to use as the container file.

`port` can be specified in the container file, using a EXPOSE directive. If a value other than zero is specified in the config, that takes precedence over the value in the Expose.

A sample program using the container `config` is

<!-- prettier-ignore -->
```python {filename="app.star"}
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
