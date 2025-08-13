---
title: "Configuration"
weight: 200
summary: "Configuration options for the OpenRun server and client."
---

Most configuration options specified in the following sections are for the OpenRun server. The OpenRun client CLI, which talks with the OpenRun server using unix domain sockets, uses a small subset of the config properties. If the OpenRun client runs on the same machine as the server, then the same config file can be used for both. See [here]({{< ref "security/#admin-api-access" >}}) for details.

{{< cards >}}
{{< card link="overview" title="Overview" subtitle="Configuration overview, OPENRUN_HOME env" icon="information-circle" >}}
{{< card link="networking" title="Ports and Certificates" subtitle="Setting up ports, TLS certs, certificate signing " icon="adjustments" >}}
{{< card link="security" title="Security" subtitle="Admin account, admin API access, github repo security" icon="shield-check" >}}
{{< card link="authentication" title="App authentication" subtitle="App authentication using admin account, OAuth account config" icon="badge-check" >}}
{{< card link="secrets" title="Secrets Management" subtitle="Secrets management, with AWS secrets manager, env, vault and properties file" icon="lock-closed" >}}
{{< /cards >}}
