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

will create an app at `https://localhost:25223/streamlit_app`. On the first API call to the app, the image is built from the defined spec and the container is started.

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
