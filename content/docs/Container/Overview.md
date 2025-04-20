---
title: "Container Overview"
weight: 100
summary: "Overview of Clace containerized apps"
---

Clace builds the image and manages the container lifecycle for containerized apps. Clace fetches the source code, creates the image, starts the container, does health checks on the container and stops the container when idle. Appspecs allow existing source code to be used with Clace with no code changes required.

## App Specs

Clace app specs are defined at https://github.com/claceio/appspecs. Most specs use containers, the `proxy` spec is an exception.

The `image` spec specifies the image to use. for example

```shell
clace app create --spec image --approve --param image=nginx \
  --param port=80 - nginxapp.localhost:/
```

downloads the nginx image, starts it and proxies any request to `https://nginxapp.localhost:25223` to the nginx container's port 80. The container is started on the first API call, and it is stopped automatically when there are no API calls for 180 seconds.

For all other specs, the `Containerfile` is defined in the spec. For example, for the `python-streamlit` spec, the Containerfile is [here](https://github.com/claceio/appspecs/blob/main/python-streamlit/Containerfile). Running

```shell
clace app create --spec python-streamlit --branch master \
  --approve github.com/streamlit/streamlit-example /streamlit_app
```

will create an app at `https://localhost:25223/streamlit_app`. On the first API call to the app, the image is built from the defined spec and the container is started. The `python-gradio` spec does the same for gradio apps.

## App Specs Listing

The specs defined currently are:

| Spec Name               | Required Params                                                                                                            | Optional Params                                                                                                                                                         | Supports Path Routing | Notes                                                                 | Example                                                                                                                                                       |
| :---------------------- | :------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------- | :-------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| container               |                                                                                                                            | <ul><li><b>port</b> : The port number within container, optional if EXPOSE directive is present</li></ul>                                                               | Depends on app        | Requires app code to have a Containerfile/Dockerfile                  |
| image                   | <ul><li><b>image</b>: The image to use for the container</li> <li><b>port</b> : The port number within container</li></ul> |                                                                                                                                                                         | Depends on app        | No source url required when creating app, use - as url                | `clace app create --spec image --approve --param image=nginx --param port=80 - nginxapp.localhost:/`                                                          |
| proxy                   | <ul><li><b>url</b>: The url to which requests should be proxied</li> </ul>                                                 |                                                                                                                                                                         | No                    | No source url required when creating app, use - as url                | `clace app create --spec proxy --approve -param url=https://clace.io - proxyapp.localhost:/`                                                                  |
| python-wsgi             |                                                                                                                            | <ul><li><b>APP_MODULE</b>: The module:app for the WSGI app. Defaults to app:app, meaning app in app.py</li> </ul>                                                       | Depends on app        | Runs Web Server Gateway Interface (WSGI) apps using gunicorn          |
| python-asgi             |                                                                                                                            | <ul><li><b>APP_MODULE</b>: The module:app for the ASGI app. Defaults to app:app, meaning app in app.py</li> </ul>                                                       | Depends on app        | Runs Asynchronous Server Gateway Interface (ASGI) apps using uvicorn  |
| python-flask            |                                                                                                                            | <ul><li><b>port</b> : The port number within container. If EXPOSE directive is present, that is used. Defaults to 5000</li></ul>                                        | Depends on app        | Runs app using flask dev server                                       |
| python-streamlit        |                                                                                                                            | <ul><li><b>app_file</b> : The file name of the streamlit app to run. Default streamlit_app.py</li></ul>                                                                 | Yes                   |                                                                       | `clace app create --spec python-streamlit --branch master --approve github.com/streamlit/streamlit-example /streamlit_app`                                    |
| python-streamlit-poetry |                                                                                                                            | <ul><li><b>app_file</b> : The file name of the streamlit app to run. Default streamlit_app.py</li></ul>                                                                 | Yes                   | Installs packages using poetry                                        |
| python-fasthtml         |                                                                                                                            | <ul><li><b>APP_MODULE</b>: The module:app for the ASGI app. Defaults to app:app, meaning app in app.py</li> </ul>                                                       | Depends on app        | Runs app using uvicorn                                                | `clace app create --approve --spec python-fasthtml --param APP_MODULE=basic_ws:app  https://github.com/AnswerDotAI/fasthtml/examples fasthtmlapp.localhost:/` |
| python-gradio           |                                                                                                                            | <ul><li><b>app_file</b> : The file name of the gradio app to run. Default run.py</li></ul>                                                                              | Yes                   |                                                                       | `clace app create --spec python-gradio --approve github.com/gradio-app/gradio/demo/blocks_flag /gradio_app`                                                   |
| go                      | <ul><li><b>port</b> : The port number within container</li></ul>                                                           | <ul><li><b>MAIN_PACKAGE</b> : The go module to build, default ".". Pass as a `--carg` instead of `--param`.</li><li><b>APP_ARGS</b> : Args to pass to the app</li></ul> | Depends on app        | CGO is disabled; go.mod has to be present; app should bind to 0.0.0.0 | `clace app create --approve --spec go --param port=8080 --param APP_ARGS="-addr 0.0.0.0:8080" --branch master github.com/golang/example/helloserver /goapp`   |

## App Environment Params

For containerized apps, all params specified for the app (including ones specified in `params.star` spec) are passed to the container at runtime as environment parameters. `CL_APP_PATH` is a special param passed to the container with the app installation path (without the domain name). `PORT` is also set with the value of the port number the app is expected to bind to within the container.

For example, the command

```sh
clace app create --approve --spec python-fasthtml \
  --param APP_MODULE=basic_ws:app \
  https://github.com/AnswerDotAI/fasthtml/examples fasthtmlapp.localhost:/
```

creates a FastHTML based app. The `APP_MODULE` env param is passed to the Container and passed to the startup command line in the [Containerfile](https://github.com/claceio/appspecs/blob/a06a59a91d99520e271c6f3df68b6fb8292dbf50/python-fasthtml/Containerfile#L41).

To update params, run

```sh
clace param update APP_MODULE basic_app:app fasthtmlapp.localhost:/
```

Param updates are staged, they can be promoted after verification. To delete a param, pass `-` as the value to the update. Use `clace param list` to view app params.

Params can be set to secrets, by setting the value as `{{secret "vault_prod" "MY_KEY_NAME"}}`. The secret is resolved when the container is started and the value is passed to the container in its env.

{{<callout type="info" >}}
**Note:** Staged param updates are a powerful mechanism to ensure that config changes do not break your apps. For example, if BUCKET_NAME is a param pointing to a S3 bucket, the param change can be staged. The staging app can be tested to ensure that the new bucket is functional and there are no IAM/key related errors. Once the staging app is working, the app can be promoted. Code changes are easy to test, but config changes can cause env specific errors. Configuration related issues are a common cause of outages during deployment. Clace enables you to avoid such errors.
{{</callout>}}

## Container Build Args

If the Containerfile has an argument, the arg can be passed during the app create. Most python specs have the python version as an argument, For example, https://github.com/claceio/appspecs/blob/a06a59a91d99520e271c6f3df68b6fb8292dbf50/python-fasthtml/Containerfile#L2 sets

```
ARG PYTHON_VERSION=3.12.5-slim
```

To change this during app creation, pass `--carg PYTHON_VERSION=3.11.1`. For example,

```sh
clace app create --approve --spec python-fasthtml \
  --param APP_MODULE=basic_ws:app \
  --carg PYTHON_VERSION=3.11.1 \
  https://github.com/AnswerDotAI/fasthtml/examples fasthtmlapp.localhost:/
```

To update args, run

```sh
clace app update-metadata carg PYTHON_VERSION=3.11.2 fasthtmlapp.localhost:/
```

Like all metadata updates, arg updates are staged. Pass `--promote` to promote immediately or run `app promote` to promote from stage to prod.

{{<callout type="info" >}}
**Note:** The slim images are smaller, but they lack some debugging tools. The regular image can be used during development.
{{</callout>}}

## Container Options

To set CPU and memory limits and other options for the container, pass `--copt optkey[=optvalue]` to the app create command. For example, `--copt cpu-shares=1000`

```sh
clace app create --approve --spec python-fasthtml \
  --param APP_MODULE=basic_ws:app \
  --copt cpu-shares=1000 \
  https://github.com/AnswerDotAI/fasthtml/examples fasthtmlapp.localhost:/
```

sets the CPU shares for the container to 1000.

To update container options, run

```sh
clace app update-metadata copt cpu-shares=500 fasthtmlapp.localhost:/
```

Like all metadata updates, option updates are staged. Pass `--promote` to promote immediately or run `app promote` to promote from stage to prod.

{{<callout type="info" >}}
**Note:** By default there are no limits set for the containers. That allows for full utilization of system resources. To avoid individual apps from utilizing too much of the system resources, CPU/memory limits can be set.
{{</callout>}}

## Volumes

Clace automatically manages volumes for containers. Volumes definitions are picked from:

- The `Dockerfile`/`Containerfile` in the source or spec
- The container config in the app definition `app.star`
- The app metadata, `container-volume`/`cvol`

For named and unnamed volumes, Clace creates a unique named volume for each app. This volume is mounted across app updates.

Bind mounts are supported for mounting secrets into the container. If the source has a template file `secret.tmpl` which needs to be loaded into the container at `/app/secret.ini`, a volume can be defined like `cl_secret:secret.tmpl:/app/secret.ini`. The template file is passed the environment params and the generated file is bound into the container. For example, if the template file contains

```{filename="secret.tmpl"}
[DEFAULT]
{{range $k, $v := .params}}
{{- $k -}} = {{- $v }}
{{end}}
```

the params are generated in the ini file format. See [streamlit spec](https://github.com/claceio/appspecs/blob/main/python-streamlit/app.star#L10) for an example of using this.

To define the volume in the app config, add

```{filename="secret.tmpl"}
    container=container.config(container.AUTO, port=param.port, volumes=[
        "cl_secret:secret.tmpl:/app/secret.ini",
    ]),
```

To set the volume info in the app metadata, run

```sh
clace app update-metadata cvol --promote "cl_secret:secret.tmpl:/app/secret.ini" /APPPATH
```

multiple values are supported for `cvol`.
