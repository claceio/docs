---
title: "Action Apps"
weight: 350
summary: "Apps which expose an autogenerated UI for simple backend actions"
---

Actions allow apps to expose an autogenerated UI for simple backend actions. For use cases where an existing CLI application or API needs to be exposed as a web app, actions provide an easy solution. An app can have one or more actions defined. Each action has to be given a unique path, which does not conflict with any other route defined for the app. See weather app [code](https://github.com/claceio/apps/blob/main/misc/weather/app.star):[demo](https://utils.demo.clace.io/weather) for an example of using Actions.

## Sample Action

First, define the parameters to be exposed in the form UI. Create a `params.star` file with the [params]({{< ref "/docs/develop/#app-parameters" >}}). For example,

```python {filename="params.star"}
param("dir", description="The directory to list files from", default="/tmp")

param("detail", type=BOOLEAN, description="Whether to show file details", default=True)
```

This app defines a run handler which runs `ls` on the specified directory. The output text is returned.

```python {filename="app.star"}
load ("exec.in", "exec")

def run(dry_run, args):
   if args.dir == "." or args.dir.startswith("./") or args.dir == ".." or args.dir.startswith("../"):
       return ace.result("Validation failed", param_errors={"dir": "relative paths not supported"})

   cmd_args = ["-Lla" if args.detail else "-La", args.dir]
   out = exec.run("ls", cmd_args)
   if out.error:
       return ace.result(out.error)
   return ace.result("File listing for " + args.dir, out.value)

app = ace.app("List Files",
   actions=[ace.action("List Files", "/", run, description="Show the ls -a output for specified directory")],
   permissions=[
     ace.permission("exec.in", "run", ["ls"]),
   ],
)
```

The app, when accessed will look as shown below, with the `ls` command output displayed:

<picture  class="responsive-picture" style="display: block; margin-left: auto; margin-right: auto;">
  <source media="(prefers-color-scheme: dark)" srcset="/images/list_filesd_dark.png">
  <source media="(prefers-color-scheme: light)" srcset="/images/list_filesd_light.png">
  <img alt="List files app" src="/images/list_files_light.png">
</picture>

## Action Definition

An action is defined using the `ace.action` struct. The fields in this structure are:

|   Property    | Optional |     Type     | Default |                            Notes                            |
| :-----------: | :------: | :----------: | :-----: | :---------------------------------------------------------: |
|     name      |  false   |    string    |         |                       The action name                       |
|     path      |  false   |    string    |         |               The path to use within app path               |
|      run      |  false   |   function   |         |              The function to run on execution               |
|    suggest    |   true   |   function   |  none   |               The function to run on suggest                |
|  description  |   true   |    string    |  none   |               The description for the action                |
|    hidden     |   true   | list strings |  none   | The params which should be hidden in the UI for this Action |
| show_validate |   true   |   boolean    |  False  |     Whether to show an Validate option for this action      |

The name and description are shown in the app UI. The app params are displayed in a form. `BOOLEAN` types are checkboxes, others are text boxes.

When the form is submitted, the `run` function is called. The params are passed as an `args` argument. The response as returned by the handler is shown on the UI.

{{<callout type="warning" >}}
In the action handler function, use `args` argument to get the values from the form. Referencing `params` will give the default values for the parameters, not the actual values passed in.
{{</callout>}}

The `hidden` property can be used to hide params for specific Actions. Set it to the list of params to hide, for example `hidden=["param1"]`.

## Action Result

The handler returns an `ace.result` struct. The fields in this structure are:

|   Property   | Optional |  Type  | Default  |                                                                                                                 Notes                                                                                                                 |
| :----------: | :------: | :----: | :------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|    status    |   true   | string |          |                                                                                                       The action status message                                                                                                       |
|    values    |   true   |  list  |    []    |                                                                                         The actions output, list of strings or list of dicts                                                                                          |
|    report    |   true   | string | ace.AUTO | The type of report to generate. Default is `ace.AUTO`, where it is selected based on response type. Other options are `ace.JSON`, `ace.TEXT`, `ace.TABLE`, `ace.DOWNLOAD` and `ace.IMAGE`. Any other value is a custom template name. |
| param_errors |   true   |  dict  |    {}    |                                                               The validation errors to report for each param. The key is the param name, the value is the error message                                                               |

## Validating Params

The `run` handler can validate the parameters. If there are errors, it can return a validation error like

```python {filename="app.star"}
  def run(dry_run, args):
    if args.dir == "." or args.dir.startswith("./") or args.dir == ".." or args.dir.startswith("../"):
       return ace.result("Validation failed", param_errors={"dir": "relative paths not supported"})
    if dry_run:
       return ace.result("Validation successful")

    # Actual code for run handler
```

Errors can be reported for multiple params. If the action definition has `show_validate=True`, then a Validate option will show up in the UI. Calling that will invoke the run handler with `dry_run=True`. The run handler should return after the param validation when dry_run is true.

## Suggest Handler

If a suggest handler is defined for an action, then a Suggest button shows up in the UI. Suggest allows property values to be populated dynamically. For example, if the app has three params A, B and C, and all are empty initially. The first suggest can do `return {"A": ["avalue1", "avalue2", "avalue3"]}`. This will populate the A param with a dropdown. A subsequent suggest call can populate the value for B, with a list of options or with an actual value. The suggest handler is optional. A sample suggest handler is

```python {filename="app.star"}
def suggest(args):
    if not args.A:
        alist = []
        res = store.select(table.adata, {})
        for aval in res.value:
            alist.append(aval.name)
        return {"A": alist}
    else:
        if not args.B:
            res = store.select_one(table.adata, {"A": args.A})
            return {"B": res.value.bval}
    return {}
```

See weather app [code](https://github.com/claceio/apps/blob/main/misc/weather/app.star):[demo](https://utils.demo.clace.io/weather) for an example of using suggest.

## Report Types

The response `values` can be a list of string or a list of dicts. The report is generated automatically by default. For list of strings, the report is a TEXT report. For list of dicts, the report can be either

- TABLE - selected if all dict values for the first row are simple types
- JSON - selected if any of the values for the first row is a complex type (like dict or list)

For TABLE report, the fields from the first row are used as columns. Extra fields in subsequent rows are ignored. For JSON report, a JSON tree representation of each row is shown. The report type can be set to specific type instead of using AUTO.

## Custom Templates

If the `report` type is set to any value other than `ace.AUTO/TEXT/JSON/TABLE`, that is treated as a custom template to use. The template should be defined in a `*.go.html` file. Either the file name can be used or a template/block name can be used. See [template]({{< ref "docs/develop/templates/#template-file-location" >}}) for details.

For styling, Clace uses DaisyUI by default, so default styles are reset. The custom template can use inline styles or it can use TailwindCSS/DaisyUI. For DaisyUI, the app has to be run in dev mode first for the style.css to be generated. See [styling]({{< ref "docs/develop/styling/#tailwindcss" >}}) for details.

See dictionary [code](https://github.com/claceio/apps/tree/main/misc/dictionary):[demo](https://utils.demo.clace.io/dict) for an actions example app which shows different type of reports.

## Param Value Selector

For some params, it is useful to be able to provide a list of values from which the user can choose. The way this is supported is by using an options param. If `param1` is a param which should show up as a selector, then define another param with the name `options-param1`, of type `LIST`. Set a default value for `options-param1` with the values to show in the selector dropdown. For example

```python {filename="params.star"}
param("param1", description="The param1 description", default="option1")

param("options-param1", type=LIST, description="Options for param1", default=["option1", "option2"])
```

In the UI, `options-param1` is not displayed. `param1` is show with a selector, having `option1` and `option2` as options. See [dictionary](https://github.com/claceio/apps/tree/main/misc/dictionary) for an app which uses this.

This approach is used for flexibility, instead of directly allowing the options to be configured for the param. The options param approach has the flexibility that when an app is installed, the options can be configured for the installation. This avoids having to maintain different copies of the app code. For example:

```bash
clace app create --approve --param options-param1='["option1", "option2", "options3"]' /mycode /myapp
```

adds a new `options3` option.

## Display Types

For string type params, the `display_type` property can be set to `FILE`, `PASSWORD` or `TEXTAREA`. If no value is set, the field shows as a text input box. `FILE` param shows as a file upload input. `PASSWORD` shows as a password input. `TEXTAREA` shows as a text area.

## File Handling

For `FILE` display type, the Action app user can upload a file. The file is uploaded to a temp file on the server and the file name is available through the `args.param_name`. The file can be process as required from disk. Multiple `FILE` type params are supported, each param can upload one file only. The temp files are deleted at the end of the handler function execution.

To return file as output for the Action, using the [`fs.serve_tmp_file`]({{< ref "/docs/plugins/catalog/#serve_tmp_file" >}}) API. This makes a file on disk available through an API.

See number_lines app [code](https://github.com/claceio/apps/blob/main/misc/num_lines/app.star):[demo](https://utils.demo.clace.io/num_lines) for an example of using this API. Use `report=ace.DOWNLOAD` property in the `ace.result` to generate a file download link.

Files from the system temp directory and from `/tmp` are accessible by default for `serve_tmp_file` API. The file is deleted from disk by default after the first download. This can be configured at the system level using

```toml {filename="clace.toml"}
[app_config]
fs.file_access = ["$TEMPDIR", "/tmp"]
```

To set this at the app level, run

```
clace app update-metadata conf --promote fs.file_access='["/var/tmp", "$TEMPDIR", "/tmp"]' /myapp
```

## Multiple Actions

Multiple actions can be defined for an app. Each action should have a dedicated path. If there are multiple actions, a switcher dropdown is automatically added for the app. The order of entries in the dropdown is the same order as defined in the app.

See weather app [code](https://github.com/claceio/apps/blob/main/misc/weather/app.star):[demo](https://utils.demo.clace.io/weather) for an example of using multiple actions in one app.
