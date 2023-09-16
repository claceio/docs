---
title: "Configuration"
description: "Securely develop and deploy internal web applications"
weight: 200
---

Configuration is used to setup the Clace server and also enable the Clace client, which talks with the Clace server over a REST API. Most configuration options specified in the following sections are for the Clace server. If the Clace client runs on the same machine as the server, then the same config file can be used for both.

If running the Clace client from a remote machine, the config options require for the client are:

```toml
server_url = "http://127.0.0.1:25223"
admin_user = "admin"
admin_password = "" # Change to actual password
```

These can be specified in a client config file or can be set in the CLI command line. All other config entries are ignored by the Clace client. Note that to connect to a Clace server over HTTP remotely, the server needs to be bound to the all interface(0.0.0.0), see [here]({{< ref "networking" >}}).