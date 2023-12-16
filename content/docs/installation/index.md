---
title: "Installation"
weight: 100
summary: "How to install Clace and do initial setup"
date: 2023-10-05
---

## Install Release Build

To install the latest release build, run the install script. Note down the password printed. Add the env variables as prompted and then start the service.

```shell
curl -L https://clace.io/install.sh | sh
source $HOME/clhome/bin/clace.env
clace server start &
clace app create --approve /disk_usage github.com/claceio/clace/examples/disk_usage/
```

The app should be available at [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage) after allowing the self-signed certificate. `admin` is the username and use the password printed by the install script. See [start the service]({{< ref "#start-the-service" >}}) for details.

## Install from Source

To install from source

- Ensure that a recent version of [Go](https://go.dev/doc/install) is available, version 1.21.0 or newer.
- Checkout the Clace repo.
- The below instructions assume you are using $HOME/clhome/clace.toml as the config file and $HOME/clhome as the work directory location.

First add the below env variables to your shell .profile or .bash_profile:

```shell
export CL_HOME=$HOME/clhome
export CL_CONFIG_FILE=$CL_HOME/clace.toml
export PATH=$CL_HOME/bin/:$PATH
```

Source the update profile file, like `source ~/.bash_profile`. Build the Clace binary

```shell
# Ensure go is in the $PATH
mkdir -p $CL_HOME/bin
mkdir $HOME/clace_source && cd $HOME/clace_source
git clone -b main https://github.com/claceio/clace && cd clace
go build -o $CL_HOME/bin/clace ./cmd/clace/
```

## Initial Configuration

To use the clace service, you need an initial config file with the service password and a work directory. Create the clace.toml file, and create a randomly generate password for the **admin** user account

```shell
clace password > $CL_HOME/clace.toml
```

This will print a random password on the screen, note that down as the password to use for accessing the applications.

## Start the service

To start the Clace server, run

```shell
clace server start
```

The service logs will be going to $CL_HOME/logs. To get the logs on the console also, you can add `-c -l DEBUG` to the server start command. The service will be started on [https://localhost:25223](https://127.0.0.1:25223) by default.

## Load an App

To create an app, run the Clace client

```shell
clace app create --dev /disk_usage $HOME/clace_source/clace/examples/disk_usage/
```

To audit and approve the app's security policies, run

```shell
clace app audit --approve /disk_usage
```

This will create an app at /disk_usage with the example disk_usage app. The disk_usage app provides a web interface for the [du command](https://man7.org/linux/man-pages/man1/du.1.html), allowing the user to explore the subfolders which are consuming most disk space.

To access the app, go to [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage). Use `admin` as the username and use the password previously generated. Allow the browser to connect to the self-signed certificate page. Or connect to [http://127.0.0.1:25222/disk_usage](http://127.0.0.1:25222/disk_usage) to avoid the certificate related warning.

The code for the disk usage app is in [GitHub](https://github.com/claceio/clace/tree/main/examples/disk_usage/app.star). app.star is the starlark config and app.go.html is the html template. The other files are generated files and are created by Clace during app development.
