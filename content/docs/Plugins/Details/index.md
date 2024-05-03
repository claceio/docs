---
title: "Plugin Details"
weight: 200
date: 2024-02-18
summary: "Details of Clace Plugins"
---

The page lists the available plugins and their API details.

## Database Storage

The `store.in` plugin supports a document store interface for writing data to SQLite (PostgreSQL support is coming soon). See [store]({{< ref "store" >}}) for details.

## HTTP Plugin

The `http.in` plugin supports making HTTP API calls. The APIs available are:

|     API     | Type  |        Notes         |
| :---------: | :---: | :------------------: |
|   **get**   | Read  |   HTTP Get request   |
|  **head**   | Read  |  HTTP Head request   |
| **options** | Read  | HTTP Options request |
|  **post**   | Write |  HTTP Post request   |
|   **put**   | Write |   HTTP Put request   |
| **delete**  | Write | HTTP Delete request  |
|  **patch**  | Write |  HTTP Patch request  |

All the API's support the following parameters:

- **url** (string, required) : the url to send the request to
- **params** (dict, optional) : url params to send
- **headers** (dict, optional) : HTTP headers to send
- **body** (string, optional) : body to send
- **form_body** (dict, optional) : form body to send
- **form_encoding** (string, optional) : the form encoding to use, `application/x-www-form-urlencoded` (default) or `multipart/form-data`
- **json_body** (object, optional) : the object to send as json encoded body
- **auth** (tuple(string, string), optional): HTTP basic auth username and password

The response for all API's (`value` within `plugin_response`) contains following properties:

- **url** (string): the url the response is for
- **status_code** (int): the HTTP status code
- **headers** (dict): the output headers
- **encoding** (string): the transfer encoding header
- **body** (string) : the response body as a string
- **json** (object) : the response body un-marshalled as a json

If the API calls fails to go through then the plugin response `error` property will be set. If the APi goes through, then the response `error` will not be set, even if API call fails with an HTPP error. The `status_code` will indicate whether the API succeeded on the server. To handle all possible error conditions, do (change to handle all 2xx codes if required)

```python
ret = http.get("http://localhost:9999/test")
if ret.error or ret.value.status_code != 200:
    return # error handling

val = ret.value.json()
# success handling
```

## Exec Plugin

The `exec.in` plugin allows running external commands, starting a new process for the specified command. The APIs available are:

|   API   |    Type    |               Notes               |
| :-----: | :--------: | :-------------------------------: |
| **run** | Read/Write | Runs the command as a new process |

The API supports the following parameters:

- **path** (string, required) : the command to run
- **args** (list of strings, optional) : arguments to pass to the cmd
- **env** (list of strings, optional) : the env to pass to the cmd, in the form `key=value`
- **process_partial** (bool, optional) : whether to process the output when there is a failure

The response for the API (`value` within `plugin_response`) is of type list of strings. The stdout is scanned and split on newlines. The list of lines is returned. For example

```python
   ret = exec.run("ls", ["-l", "/"], process_partial=True)
   if ret.error:
       return {"Error": ret.error}

   for line in ret.value:
       # Process lines
```

{{<callout type="info" >}}
**Note:** Only first 100MB of the command stdout output is scanned currently, the rest is discarded.
{{</callout>}}

## FS Plugin

The `fs.in` allows working with local file system. The APIs available are

|   API    | Type |                         Notes                          |
| :------: | :--: | :----------------------------------------------------: |
| **abs**  | Read |   Returns the absolute path for given relative path    |
| **list** | Read |           List files in specified directory            |
| **find** | Read | Find files under specified directory matching criteria |

The `abs` API supports the following parameter:

- **path** (string, required) : the file path

The response for the API (`value` within `plugin_response`) is of type string, the absolute path for given path.

The `list` API supports the following parameters:

- **path** (string, required) : the directory path
- **recursive_size** (bool, optional, default false) : whether to include the recursive size of sub-directories
- **ignore_errors** (bool, optional, default false) : whether to ignore errors when accessing entries

The response for the API is a list of type `FileInfo`. The `FileInfo` struct contains the fields:

- **name** (string) : the file name
- **size** (int) : the file size in bytes, rounded up to 4K
- **is_dir** (bool) : is it a directory
- **mode** (int) : file mode info

The `find` API supports the following parameters:

- **path** (string, required) : the directory path
- **name** (string, optional) : the file name glob pattern to match
- **limit** (int, optional, default 10K, max 100K) : the limit on number of entries to return
- **min_size** (int, optional) : the minimum file size in bytes to look for
- **ignore_errors** (bool, optional, default false) : whether to ignore errors when accessing entries

The response for the `find` API is a list of type `FileInfo`, same as returned by `list`.
