---
title: "Quick Start"
weight: 50
summary: "Quick Start guide on using Clace"
date: 2024-02-03
---

# Installation

To install the latest release build, run the install script on Linux, OSX and Windows with WSL. Note down the password printed. Add the env variables as prompted and then start the service.

```shell
curl -L https://clace.io/install.sh | sh
source $HOME/clhome/bin/clace.env
clace server start &
clace app create --approve /disk_usage github.com/claceio/clace/examples/disk_usage/
```

The app should be available at [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) after allowing the self-signed certificate. `admin` is the username and use the password printed by the install script.

See [installation]({{< ref "installation" >}}) for details. See [config options]({{< ref "configuration" >}}) for options. To enable Let's Encrypt certifcate, see [Automatic SSL]({{< ref "configuration/networking/#enable-automatic-signed-certificate" >}}).

On Windows without WSL, download the release binary zip from [releases](https://github.com/claceio/clace/releases) or [install from source]({{< ref "installation/#install-from-source" >}}) if you have go installed.
