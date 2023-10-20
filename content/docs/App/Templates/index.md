---
title: "Templates"
weight: 500
date: 2023-10-06
summary: "HTML templates functions, static file handling and customizations"
---

Clace uses [Go HTML templates](https://pkg.go.dev/html/template@go1.21.2) for returning data to the client. See [here](https://pkg.go.dev/text/template@go1.21.2) for an overview of the template syntax.

The [Sprig template library functions](http://masterminds.github.io/sprig/) are included automatically. Two functions from Sprig which are excluded for security considerations are `env` and `expandenv`.

Two extra functions are added for handling static file paths.

## static function

This function takes a file name and returns the url for a file in the static folder with a sha256 hash included in the file name. This approach is based on the [hashfs library](https://github.com/benbjohnson/hashfs). If the `static` folder contains a file `file1` with the content `file1data`, then a call to `static "file"` will return `/test/static/file1-ca9e40772ef9119c13100a8258bc38a665a0a1976bf81c96e69a353b6605f5a7`, assuming the app is installed at `/test`.

The returned file name has a hash based on the file contents. The file server used by Clace serves will serve aggressive cache headers `Cache-Control: public, max-age=31536000` when this file is referenced by the browser. When the file contents change, the hash will change and the file name will change. The files on disk are not renamed, only the filesystem used by the Clace server in memory sees the hashed file names.

This approach allows for a build-less system with the aggressive static asset caching. The usual approach for this requires the static file to be renamed to have the hash value in the file name on disk. This require a build step to do the file renaming. The hashfs approach can avoid the build step while having the additional overhead that the file hash has to be generated once every time a new static file is referenced from a server session. Since the file is cached on the browser after first access, this overhead is not significant. The advantages in term of simplifying the deployment process by avoiding the need for a build step are much higher.

## fileNonEmpty function

The fileNonEmpty function returns a bool, indicating whether a static file with that non-hashed name is present and is not empty. This can be used to conditionally include style files if present.

For example

<!-- prettier-ignore -->
```html
{{ if fileNonEmpty "css/style.css" }}
   <link rel="stylesheet" href="{{ static "css/style.css" }}" />
{{ end }}
```

<!-- prettier-ignore-end -->

checks if the "css/style.css" file is present and not empty. If so, it is linked using the `static` function, which returns a hashed file name which can be cached aggressively.

{{< alert >}}
**Note:** The path passed to `static` and `fileNonEmpty` functions should not include static, it is automatically added. So use `{{ static "css/style.css" }}`, not `{{ static "static/css/style.css" }}`
{{< /alert >}}

## Template File Location

Templates are loaded once on app initialization. In dev mode, they are automatically reload on file updates. By default, the app source home directory is searched for template files. This can be changed by adding this directive in the `ace.app` config.

```json
settings={
    "routing": {"template_locations": ["*.go.html", "templates/*.go.html"]}
}
```

the default is `["*.go.html"]`. If additional directories are added, `"*.go.html"` still needs to present in the list since generated files are created in the app home directory. Also, all folders in the list need to contains at least one template file. File names have to be unique across folders. Files are referenced by their name, without the folder name, when used in template import directives.

## File Contents

When using custom layout, the app developer has to create the `index.go.html` file. Adding a directive like:

```html
{{ template "clace_gen_import" . }}
```

in the head section ensures that the auto generated `clace_gen_import` directives are loaded. This will include the style files, HTMX library and the live reload functionality will be enabled in dev mode.

In Clace layout mode (the default), the auto generated `index_gen.go.html` file is used. The app developer has to provide a `clace_body` block. It can be in any file, the convention is to use `app.go.html`. For example:

<!-- prettier-ignore -->
```html
{{block "clace_body" .}}
   Data is {{.Data}}
{{end}}
```

<!-- prettier-ignore-end -->

The `.Data` binding has the response as returned by the handler function for the route.
