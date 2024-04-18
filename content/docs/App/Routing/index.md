---
title: "Request Routing"
weight: 200
date: 2023-10-06
summary: "Defining API routes, handling pages and fragments"
---

The request routing layer in Clace is built on top of the [chi](https://github.com/go-chi/chi) routing library. The routing is built for hypermedia exchange, so all routes are defined in terms of pages and fragments within the pages. This grouping of requests helps make it clear which API does what and provide an easy mechanism to deal with partial HTMX driven requests and full page refreshes. Simpler application might have one page with some interactions within that. Larger applications can be composed of multiple pages, each page having some interactive fragments.

## Routes

The app contains an `routes` array, which defines all the routes for the app. For example, the app definition

```python
app = ace.app("hello1",
              routes = [
                 ace.page("/"),
                 ace.page("/help", "help.go.html")
              ]
             )
```

defines two routes. `/` routes to the default index page, `/help` routes to the help page.

## Page

`ace.page` is used to define the properties for a single page. The parameters for `ace.page` are:

| Property  | Optional |      Type      |                        Default                         |                     Notes                     |
| :-------: | :------: | :------------: | :----------------------------------------------------: | :-------------------------------------------: |
|   path    |  False   |     string     |                                                        |       The route, should start with a /        |
|   full    |   True   |     string     | index.go.html if custom layout, else index_gen.go.html |  The template to use for full page requests   |
|  partial  |   True   |     string     |                          None                          | The template to use for partial page requests |
|  handler  |   True   |    function    |                  handler (if defined)                  |   The handler function to use for the route   |
| fragments |   True   | ace.fragment[] |                           []                           |              The fragment array               |
|  method   |   True   |     string     |                          GET                           | The HTTP method type: GET,POST,PUT,DELETE etc |
|   type    |   True   |     string     |                          html                          |        The response type, html or json        |

## Fragment

The fragments array in the page definition defines the API interactions within the page. The parameters for `ace.Fragment` are:

| Property | Optional |   Type   |       Default       |                     Notes                     |
| :------: | :------: | :------: | :-----------------: | :-------------------------------------------: |
|   path   |  False   |  string  |                     |     The route, should not start with a /      |
| partial  |   True   |  string  | Inherited from page |   The template to use for partial requests    |
| handler  |   True   | function | Inherited from page |   The handler function to use for the route   |
|  method  |   True   | function |         GET         | The HTTP method type: GET,POST,PUT,DELETE etc |
|   type   |   True   |  string  |        html         |        The response type, html or json        |

{{< alert >}}
**Note:** `partial` and `handler` are inherited from the page level, unless overridden for the fragment.
{{< /alert >}}

For example, in this page definition

```python
ace.page("/game/{game_id}", full="game.go.html", partial="game_info_tmpl", handler=game_handler,
    fragments=[
        ace.fragment(
            "submit", method=ace.POST, handler=lambda req: post_game_update(req, "submit")),
        ace.fragment(
            "refresh", partial="refresh_tmpl")
    ]
)
```

there are three API's defined:

- GET /game/{game_id} : game_handler is the handler function, full page request returns game.go.html, partial HTMX request returns game_info_tmpl template.
- POST /game/{game_id}/submit : The handler is a lambda function. The game_info_tmpl template partial is inherited from the page as the response for the POST.
- GET /game/{game_id}/refresh : game_handler is inherited from the page. For full page, it returns the game.go.html response. For partial HTMX requests, refresh_tmpl template is returned.

## API Flow

The API flow is

- The API is first sent to the matching app
- Within the app, the API is routed based on the routes defined
- If there is a handler defined for the matched route, the handler function is called with the request as argument
- The response template is invoked, with an input map containing a `Data` property as returned by the handler function
- If the API type is set to json, the handler response is directly returned, with no template being used
- If [automatic error handling]({{< ref "docs/plugins/overview#automatic-error-handling" >}}) is enabled (`error_handler` is defined), then the error handler function is called if there is a error during the handler invocation. The error handler does the response processing, the templates defined in the route are not used.

## Notes

- For HTMX requests, the `partial` template is used. For regular requests, the page level `full` template is used
- If there is a function called `handler` defined, that is the default handler function for all API's
- For non-HTMX update requests (POST/PUT/DELETE), the [Post-Redirect-Get](https://en.wikipedia.org/wiki/Post/Redirect/Get) pattern is automatically implemented by redirecting to the location pointed to by the `Referer` header.
