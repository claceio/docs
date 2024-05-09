---
title: "Overview"
weight: 100
date: 2023-10-06
summary: "Overview of the Clace application development model"
---

Clace applications implement a [Hypermedia driven approach](https://hypermedia.systems/hypermedia-reintroduction/) for developing web applications. Applications return HTML fragments as API response using [Go html templates](https://pkg.go.dev/html/template). The UI uses HTML enhanced with hypermedia controls using the [HTMX library](https://htmx.org/) to implement user interactions.

The backend API routes and dependencies like CSS library, JavaScript modules etc are configured using [Starlark](https://github.com/google/starlark-go/blob/master/doc/spec.md) configuration. Any custom API handling required is implemented in handler functions also written in Starlark. Starlark is a subset of python, optimized for application configuration usecases.

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

Run `clace app create --auth=none /hello ~/myapp`. After that, the app is available at `/hello`

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

Run `clace app create --auth=none /hello2 ~/myapp2`. After that, the app is available at `/hello2`

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

Run `clace app create --auth=none --dev /hello3 ~/myapp3`. After that, the app is available at `/hello3`. Note that the `--dev` option is required for the `index_gen.go.html` file to be generated.

The name of the app is hello3. There is only one route defined, for page /, which shows a HTML page with the name of the app. The body is generated from the contents of the app.go.html file. A more verbose way to write the same app config would be

```python {filename="app.star"}
app = ace.app(name="hello3",
              custom_layout=False,
              routes = [ace.html(path="/", full="index_gen.go.html")]
             )
```

### Complete App

To create an app with a custom HTML page which shows a listing of files in your root directory, create an `~/myapp4/app.star` file with

```python {filename="app.star"}
load("exec.in", "exec")

def handler(req):
   ret = exec.run("ls", ["-l", "/"])
   if ret.error:
       return {"Error": ret.error, "Lines": []}
   return {"Error": "", "Lines": ret.value}

app = ace.app("hello1",
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

Run `clace app create --auth=none --dev --approve /hello4 ~/myapp4`. After that, the app is available at `/hello4`. Note that the `--dev` option is required for the `clace_gen_import` file to be generated which is required for live reload.

This app uses the `exec` plugin to run the ls command. The output of the command is shown when the app is accessed. To allow the app to run the plugin command, use the `clace app approve` command.

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
