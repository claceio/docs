---
title: "Installation"
description: "Securely develop and deploy internal web applications"
weight: 100
summary: "How to install Clace and do initial setup"
date: 2023-10-05
---

Clace can currently be installed from source. Other installation options will be added soon.

## Install from Source

To install from source

- Ensure that a recent version of [Go](https://go.dev/doc/install) is available, version 1.21.0 or newer
- Checkout the Clace repo, cd to the checked out folder
- Build the clace binary and place in desired location, like $HOME

```shell
# Ensure go is in the $PATH
mkdir $HOME/clace_source && cd $HOME/clace_source
git clone -b main https://github.com/claceio/clace && cd clace
go build -o $HOME/clace ./cmd/clace/
```

## Initial Configuration

To use the clace service, you need an initial config file with the service password and a work directory. The below instructions assume you are using $HOME/clhome/clace.toml as the config file and $HOME/clhome as the work directory location.

- Create the clhome directory
- Create the clace.toml file, and create a randomly generate password for the **admin** user account

```shell
export CL_HOME=$HOME/clhome && mkdir $CL_HOME
$HOME/clace password > $CL_HOME/clace.toml
```

This will print a random password on the screen, note that down as the password to use for accessing the applications.

## Start the service

To start the service, the CL_HOME environment variable has to point to the work directory location and the CL_CONFIG_FILE env variable should point to the config file.

```shell
export CL_HOME=$HOME/clhome
export CL_CONFIG_FILE=$CL_HOME/clace.toml
$HOME/clace server start
```

Add the exports to your shell profile file to automate this. The service logs will be going to $CL_HOME/logs. To get the logs on the console also, you can add `-c -l DEBUG` to the server start command.

The service will be started on [https://localhost:25223](https://127.0.0.1:25223) by default.

## Running the client

The client can be used to install and manage applications. To run the client, the CL_CONFIG_FILE environment variable should be set pointing to the config file `export CL_CONFIG_FILE=$HOME/clhome/clace.toml`.

## Load an App

To create an app, run

```shell
$HOME/clace app create --is_dev /disk_usage $HOME/clace_source/examples/disk_usage/
```

To audit and approve the app's security policies, run

```shell
$HOME/clace app audit --approve /disk_usage
```

This will create an app at /disk_usage with the example disk_usage app. The disk_usage app provides a web interface for the [du command](https://man7.org/linux/man-pages/man1/du.1.html), allowing the user to explore the subfolders which are consuming most disk space.

To access the app, go to [https://127.0.0.1:25223/disk_usage](https://127.0.0.1:25223/disk_usage). Use `admin` as the username and use the password previously generated. Allow the browser to connect to the self-signed certificate page. Or connect to [http://127.0.0.1:25222/disk_usage](http://127.0.0.1:25222/disk_usage) to avoid the certificate related warning.

The code for the example app is [here](https://github.com/claceio/clace/tree/main/examples/disk_usage/app.star). app.star is the starlark config and app.go.html is the html template. The other files are generated files and are created by the system on app initialization.
