---
title: "Installation"
description: "Securely develop and deploy internal web applications"
weight: 100
---

Clace can currently be installed from source. Other installation options will be added soon.

## Install from Source
To install from source
- Ensure that a recent version of [Go](https://go.dev/doc/install) is available, version 1.19 or newer
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
- Create the clace.toml file, with a randomly generate password for the **admin** user account

```shell
export CL_HOME=$HOME/clhome && mkdir $CL_HOME
CL_PASSWD=`openssl rand -base64 18`
echo "admin_password = \"$CL_PASSWD\"" > $CL_HOME/clace.toml
unset CL_PASSWD
```

## Start the service
To start the service, the CL_HOME environment variable has to point to the work directory location and the CL_CONFIG_FILE env variable should point to the config file.

```shell
export CL_HOME=$HOME/clhome
export CL_CONFIG_FILE=$HOME/clhome/clace.toml
$HOME/clace server start
```

Adding `export CL_HOME=$HOME/clhome` and `export CL_CONFIG_FILE=$CL_HOME/clace.toml` to your shell RC file will remove the need to always set these env variables.

The service logs will be going to $CL_HOME/logs. To get the logs on the console also, you can add `-c -l DEBUG` to the server start command.

The service will be started on [http://localhost:25223](http://127.0.0.1:25223) by default

## Running the client
The client can be used to install and manage applications. To run the client, the CL_CONFIG_FILE environment variable should be set

```shell
export CL_CONFIG_FILE=$HOME/clhome/clace.toml
$HOME/clace app list /
```

The command will give a 404 until apps are created. See the app creation page for details.
