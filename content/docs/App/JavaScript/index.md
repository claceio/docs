---
title: "JavaScript"
weight: 700
date: 2023-10-19
summary: "JavaScript dependency handling, esbuild config"
---

Clace supports importing JavaScript libraries as [JavaScript Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) . To use this feature, add

```python
    libraries=[ace.library("d3", "7.8.5")]
```

in the app definition. The fields in the `ace.library` structure are:

| Property | Optional |   Type   | Default |               Notes               |
| :------: | :------: | :------: | :-----: | :-------------------------------: |
|   name   |  false   |  string  |         | The name of the library to import |
| version  |  false   |  string  |         |    The version of the library     |
|   args   |   true   | string[] |   []    |   Arguments to pass to esbuild    |

The args array uses the [esbuild cli syntax](https://pkg.go.dev/github.com/evanw/esbuild/pkg/cli). For example, passing args as `["--minify"]` will enable minification for the imported module.

## JavaScript Modules

JavaScript modules (also called ESM or ECMAScript Modules) are a way to import Javascript libraries dynamically, providing a unique namespace for all functions. Modules, once imported, can be used in the client code without requiring any build steps. See [jvns.ca](https://jvns.ca/blog/2023/02/16/writing-javascript-without-a-build-system/) and [https://simonwillison.net](https://simonwillison.net/2023/May/2/download-esm/) for notes about this approach. Clace tries to provide an easy interface to modules, converting npm packages to module format so that subsequent code changes do not require any build steps.

## Workflow

The workflow when using modules in Clace for an app in dev mode is:

- In you home directly, install [nodejs](https://nodejs.org/en/download)
- Using npm, install package you want to use a modules. for example `npm install d3`
- Add the ace.library entry in the app config. Clace will automatically run esbuild and import the package as a module into `static/gen/esm`
- Add an importmap in the head section of the html. Like [here](https://github.com/claceio/clace/blob/8b7f0d7d0c692e0ca3c6a74e97d1913031b954a1/examples/memory_usage/index.go.html#L10).
  ```javascript
  <script type="importmap">
  {
    "imports": {
        "d3": "{{ static "gen/esm/d3-7.8.5.js"}}"
    }
  }
  </script>
  ```
- Use the library as required in your client. Like [here](https://github.com/claceio/clace/blob/8b7f0d7d0c692e0ca3c6a74e97d1913031b954a1/examples/memory_usage/static/js/app.js#L4)

```javascript
import * as d3 from "d3";
```

Creating the module is a one time step. The generated module can be checked into source code. On a new machine, to make code changes to the app, you do not need nodejs or npm to be installed.

For production deployment, no changes are required. Checkout the git repo containing the source code and create a Clace app. Clace will serve the static assets over HTTP/2 with content hash based caching. The assets are compressed for serving, there is no need usually for mimifying the modules.

## Esbuild Config

Clace includes esbuild, there is no need to install esbuild manually. The Clace server config has the entry

```toml
[system]
node_path = ""
```

The node_path property is used by esbuild, these paths are searched for packages in addition to the node_modules directories in all parent directories. See [esbuild docs](https://esbuild.github.io/api/#node-paths) for details. Paths should be separated with : on Unix and ; on Windows.

If you install the npm packages in your home directory, esbuild will pick up those without any additional configuration. Since each Clace project is importing the npm package as a module, you do not need to maintain separate node_modules for each Clace project.

If you do not want esbuild to create modules, set the node_path property in the server config to `disable`. You will have to manually download the module file into the static folder.

## Notes

- The version number specified in the `ace.library` is used to create the file name under `static/gen/esm`. The actual package version depends on what was install using npm. Ensure that the same version is installed by npm as specified in the library config.
- Only the `minify` option for esbuild has been tested with Clace. Other options like chunking the files might not work currently.
