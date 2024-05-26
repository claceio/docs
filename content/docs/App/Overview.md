---
title: "Overview"
weight: 100
date: 2023-10-06
summary: "Overview of the Clace application development model"
---

Clace supports deploying any type of app, in any language/framework, using containerized apps. Apps can also be built where the backend API is in the container but the UI is built using Clace. Clace UI applications implement a [Hypermedia driven approach](https://hypermedia.systems/hypermedia-reintroduction/) for developing web applications. Applications return HTML fragments as API response using [Go html templates](https://pkg.go.dev/html/template). The UI uses HTML enhanced with hypermedia controls using the [HTMX library](https://htmx.org/) to implement user interactions.

The backend API routes and dependencies like CSS library, JavaScript modules etc are configured using [Starlark](https://github.com/google/starlark-go/blob/master/doc/spec.md) configuration. Any custom API handling required is implemented in handler functions also written in Starlark. Starlark is a subset of python, optimized for application configuration usecases.

## App Types

Clace apps can be of three types:

- **Starlark apps**: These use the Clace plugins to implement the whole app. No containers are required for such apps.
- **Containerized apps**: The whole app is implemented in a container, Clace proxies the container results. This uses the container and proxy plugins.
- **Hybrid apps**: The backend APIs are implemented in a container. Clace is used to implement the Hypermedia based UI using Starlark handlers. This uses the http plugin to talk to the backend API and the container plugin to configure the backend.

## Structure

The structure of a Clace application is:

- One Clace application per folder, `static` sub-folder contain static assets
- An `app.star` Starlark file, defining the application configuration
- Predefined builtins, accessed through the `ace` namespace
- A global called `app`, created using `app = ace.app()` call
- An optional default handler function called `handler`. Other handlers are referenced in the route config
- An optional error handler function called `error_handler`. Defining the `error_handler` enables [automatic error handling]({{< ref "docs/plugins/overview#automatic-error-handling" >}})
- An html template file called `index.go.html` if using custom layout
- If not using custom layout, an html template block called `clace_body` defined in any `*.go.html` file, for example `app.go.html`

## App Lifecycle

The Clace app development lifecycle is:

- Create a folder for the app, with the app.star file and templates.
- Start the Clace server. Create an app using `clace app create --dev`. This runs the app in dev mode.
- In dev mode, some additional files are generated, with `_gen` in the file name. CSS dependencies and JavaScript modules are downloaded into the `static` folder.
- After the app development is done, the whole app folder can be checked into source control. There is no build step.
- Create a production app, `clace app create`, without the `--dev`. The app is now live. The Clace server can host multiple applications, each application has a dedicated path and optionally a dedicated domain.

## Examples

### Simple Text App

The hello world app for Clace is an `~/myapp/app.star` file containing:

```python {filename="app.star"}
def handler(req):
    return "hello world"

app = ace.app("hello",
        routes = [ace.api("/", type=ace.TEXT)]
)
```

Run `clace app create --auth=none ~/myapp /hello`. After that, the app is available at `/hello`

```sh
$ curl localhost:25222/hello
hello world
```

The default response type is `ace.HTML`. `ace.TEXT` and `ace.JSON` are the other options. The data returned by the handler function is converted to the type format specified in the API.

### Custom Layout HTML App

To return HTML response, a HTML template file named `*.go.html` is required. Create an `~/myapp2/app.star` file containing

```python {filename="app.star"}
app = ace.app("hello2",
        custom_layout=True,
        routes = [ace.html("/")]
)
```

and an `~/myapp2/index.go.html` file containing

```html {filename="index.go.html"}
hello world2
```

Run `clace app create --auth=none ~/myapp2 /hello2`. After that, the app is available at `/hello2`

```sh
$ curl localhost:25222/hello2
hello world2
```

The `~/myapp2/index.go.html` can be updated to have a complete HTML page. Use the command `clace app reload --promote /hello2` to pick up changes. This app is using `custom_layout=True` which means the app developer has to provide the complete HTML.

### Default Layout HTML App

The default is `custom_layout=False` meaning app developer has to provide only the HTML body, Clace will automatically generate the rest of the HTML. For using the auto generated HTML templates, the app has to be created in dev mode using the `--dev` option.

Create an `~/myapp3/app.star` file containing

```python {filename="app.star"}
app = ace.app("hello3",
        routes = [ace.html("/")]
)
```

and an `~/myapp3/app.go.html` file containing

<!-- prettier-ignore -->
```html {filename="app.go.html"}
{{block "clace_body" .}}
   hello world3
{{end}}
```

<!-- prettier-ignore-end -->

Run `clace app create --auth=none --dev ~/myapp3 /hello3 `. After that, the app is available at `/hello3`. Note that the `--dev` option is required for the `index_gen.go.html` file to be generated.

The name of the app is hello3. There is only one route defined, for page /, which shows a HTML page with the name of the app. The body is generated from the contents of the app.go.html file. A more verbose way to write the same app config would be

```python {filename="app.star"}
app = ace.app(name="hello3",
              custom_layout=False,
              routes = [ace.html(path="/", full="index_gen.go.html")]
             )
```

### Sample Starlark App

To create an app with a custom HTML page which shows a listing of files in your root directory, create an `~/myapp4/app.star` file with

```python {filename="app.star"}
load("exec.in", "exec")

def handler(req):
   ret = exec.run("ls", ["-l", "/"])
   if ret.error:
       return {"Error": ret.error, "Lines": []}
   return {"Error": "", "Lines": ret.value}

app = ace.app("hello4",
              custom_layout=True,
              routes = [ace.html("/")],
              permissions = [ace.permission("exec.in", "run", ["ls"])]
             )
```

and an `~/myapp4/index.go.html` file with

<!-- prettier-ignore -->
```html {filename="index.go.html"}
<!doctype html>
<html>
  <head>
    <title>File List</title>
    {{ template "clace_gen_import" . }}
  </head>
  <body>
    {{ .Data.Error }}
    {{ range .Data.Lines }}
       {{.}}
       <br/>
    {{end}}
  </body>
</html>
```

<!-- prettier-ignore-end -->

Run `clace app create --auth=none --dev --approve ~/myapp4 /hello4`. After that, the app is available at `/hello4`. Note that the `--dev` option is required for the `clace_gen_import` file to be generated which is required for live reload.

This app uses the `exec` plugin to run the ls command. The output of the command is shown when the app is accessed. To allow the app to run the plugin command, use the `clace app approve` command.

{{<callout type="warning" >}}
**Note:** If running on Windows, change `ls` to `dir`. Else, use the `fs` plugin to make this platform independent. See https://github.com/claceio/apps/blob/main/system/disk_usage/app.star.
{{</callout>}}

### Containerized App

A containerized apps needs to have a `Containerfile` (or `Dockerfile`) to define how the image is built. The app definition can have

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

## Building Apps from Spec

A spec (specification) can be set for an app. This makes Clace use the spec as a template to specify the app configuration. Use `app create --spec python-flask` while creating an app or change the spec using `app update-metadata spec python-flask /myapp`. The spec brings in a set of predefined files. If a file with the same name is already present in the app code, then the spec file is ignored. So if the app code and spec both define a `Containerfile`, the file from the app code takes precedence. If the app folder contains just `app.py`

```python {filename="flaskapp/app.py"}
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
```

Creating an app like `clace app create --approve --spec python-flask ./flaskapp /myapp ` will do everything required to fully define the Clace app. If the app has additional python dependencies, add a `requirements.txt` file in the app source code. By [default](https://github.com/claceio/appspecs/blob/main/python-flask/requirements.txt), only the flask package is installed. The file in the app source takes precedence.

See https://github.com/claceio/appspecs for the list of specs. The Clace server build includes these spec by default. Additional specs can de defined by creating a folder `$CL_HOME/config/appspecs`. Any directory within that is treated as a spec. If the name matches with the predefined ones the spec in the config folder takes precedence. No server restart is required after spec changes. Setting up the server by doing

```bash
cd $CL_HOME/config
git clone https://github.com/claceio/appspecs.git
```

ensures that the specs are updated to the latest version. Periodically doing a git pull on this folder refreshes the specs. Instead of cloning the main spec repo, a custom spec repo can also be used similarly. If no custom specs are defined, the specs as bundled in the Clace server build are available.

## App Parameters

Having a file `params.star` in the app source code causes Clace to load the parameters definitions from that file. Parameters are environment value which can be specified during app creation. A sample param definition is

```python {filename="params.star"}
param("port", type=INT,
      description="The port the flask app is listening on (inside the container)", default=5000)

param("app_name", description="The name for the app", default="Flask App")

param("preserve_host", type=BOOLEAN, description="Whether to preserve the original Host header", default=False)
```

This is defining three parameters. The type can be one of `STRING`(default), `INT`, `BOOLEAN`, `LIST` and `DICT`. The param structure definition is

|  Property   | Optional |                    Type                    |         Default         |                                     Notes                                     |
| :---------: | :------: | :----------------------------------------: | :---------------------: | :---------------------------------------------------------------------------: |
|    name     |  False   |                   string                   |                         |                     Has to be be a valid starlark keyword                     |
|    type     |   True   | `STRING`, `INT`, `BOOLEAN`, `LIST`or`DICT` |        `STRING`         |                                 The data type                                 |
|   default   |   True   |           Type as set for `type`           | Zero value for the type |                                                                               |
| description |   True   |                   string                   |                         |                         The description for the param                         |
|  required   |   True   |                    bool                    |          True           | If required is True and default value is not specified, then validation fails |

The parameters are available in the app Starlark code, through the `param` namespace. For example, `param.port`, `param.app_name` etc. See https://github.com/claceio/appspecs/blob/main/python-flask/app.star for an example of how this can be used.

Params are set, during app creation using `app create --param port=9000` or using `param update /myapp port 9000`. Set value to `-` to delete the param. Use `param list /myapp` to list the params.

For containerized apps, all params specified for the app (including ones not specified in `params.star` spec) are passed to the container at runtime as environment parameters. `CL_APP_PATH` is a special param passed to the container with the app installation path (without the domain name).

## Automatic Error Handling

To enable [automatic error handling]({{< ref "docs/plugins/overview#automatic-error-handling" >}}) (recommended), add an `error_handler` function like:

```python {filename="app.star"}
def error_handler(req, ret):
    if req.IsPartial:
        return ace.response(ret, "error", retarget="#error_div", reswap="innerHTML")
    else:
        return ace.response(ret, "error.go.html")
```

## More examples

There are more examples [here](https://github.com/claceio/clace/tree/main/examples). The disk_usage example uses the MVP classless library for styling and shows a basic hypermedia flow. The cowbull game examples has multiple [pages](https://github.com/claceio/clace/blob/1f2ca6b09a73112dc8c97cb0575942dba4d75f89/examples/cowbull/app.star#L89), each page with some dynamic behavior. Clace does not currently have a persistence layer. The cowbull game depends on another service for data persistence, so it is implementing a backend for frontend pattern. For styling, it uses the [DaisyUI](https://daisyui.com/) component library for Tailwind CSS. These two examples work fine with Javascript disabled in the browser, falling back to basic HTML without any HTMX extensions.

The memory_usage example uses the [d3](https://d3js.org/) library to show a interactive display of the memory usage for processes on the machine. The plot library is [automatically imported](https://github.com/claceio/clace/blob/1f2ca6b09a73112dc8c97cb0575942dba4d75f89/examples/memory_usage/app.star#L103) as a ECMAScript module and the custom [javascript code](https://github.com/claceio/clace/blob/main/examples/memory_usage/static/js/app.js) works with a [JSON api](https://github.com/claceio/clace/blob/1f2ca6b09a73112dc8c97cb0575942dba4d75f89/examples/memory_usage/app.star#L98) on the backend. The default in Clace is hypermedia exchange, JSON can be used for data API's.

These examples are live on the [demo](https://demo.clace.io/) page.
