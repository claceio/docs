---
title: "Networking: Ports and Certificates"
description: "Securely develop and deploy internal web applications"
weight: 200
---

## HTTP
For HTTP requests, by default the Clace service listens on port 25223, on the localhost(127.0.0.1) interface. This means the HTTP port can be accessed from the same machine, it cannot be accessed remotely. To configure this, update the config file

```toml
[http]
host = "127.0.0.1" # bind to localhost by default for HTTP
port = 25223 # default port for HTTP
```

to desired values. Port 0 means bind to any available port. Port -1 means disable HTTP access. Use host as `0.0.0.0` to bind to all available interfaces.


## HTTPS
For HTTPS requests, the Clace service listens on port 25224 by default, on the any(0.0.0.0) interface. This means the HTTPS port can be accessed from the same machine and also remotely. The various HTTPS config settings are:

```toml
# HTTPS port binding related Config
[https]
host = "0.0.0.0" # bind to all interfaces (if port is >= 0)
port = 25224 # port for HTTPS
enable_cert_lookup = true # enable looking for certificate files on disk before using Let's Encrypt
service_email = "" # email address for registering with Let's Encrypt. Set a value to enable automatic certs
use_staging = true # use Let's Encrypt staging server
cert_location = "$CL_HOME/config/certificates" # where to look for existing certificate files
storage_location = "$CL_HOME/run/certmagic" # where to cache dynamically created certificates

```

Port 0 means bind to any available port. Port -1 means disable HTTPS access.

## TLS Certificates
The default configuration is:
* During the first HTTPS request, `$CL_HOME/config/certificates` is looked up for a crt and key file in the PEM format matching the domain name as passed to the server. If a matching certificate is found, that is used.
* If no domain specific certificate is found, then the default certificate `default.crt` and `default.key` are looked up. If found, that is used.
* If default certificate is not found, and Lets Encrypt based certificate creation is disabled (the default), then a self-signed certificate is auto created in the certificates folder.

The intent is to allow custom certificates to be placed in the certificate folder, which will be used. If not found, a self-signed certificate is created and used. For example, if a file example.crt and example.key are found in te certificates folder, those are used for example.com domain.


## Enable Automatic Signed Certificate
Clace uses the [certmagic](https://github.com/caddyserver/certmagic) library for fully-managed TLS certificate issuance and renewal. Certmagic is disabled by default. To enable, the pre-requisites are:

* The https config is using 443 as the port number. Running on privileged ports requires additional [setup](#privileged-ports)
* There is an DNS entry created pointing your host name or domain wildcard to the IP address of the host running the Clace server. This has to be done in your DNS provider config.
* Port 443 is reachable from the public internet. This has to be done in your infrastructure provider network settings.

Once the pre-requisites are met, set the `service_email` config parameter to your email address. This enables certmagic based certificate creation. The config will look like:

```toml
# HTTPS port binding related Config
[https]
host = "0.0.0.0"
port = 443
enable_cert_lookup = true
service_email = "MY_EMAIL@example.com" # CHANGE to your email address
use_staging = true # CHANGE to false for production
cert_location = "$CL_HOME/config/certificates"
storage_location = "$CL_HOME/run/certmagic"
```

Test out the certificate creation. If the certificate is getting created, change `use_staging` to false. Let's Encrypt has strict rate limits, use the staging config to ensure that the pre-requisites are met before using the production config.

With this config, the certificates folder is looked up for any custom certificates for the domain. If not found, certmagic is used to create the certificate. Change `enable_cert_lookup` to `false` to disable local certificate lookup. If enable_cert_lookup is false, and service_email also is unset (certmagic is disabled), then the `default.crt` certificate is used for all requests.


## Privileged Ports
On Linux, binding to low ports is disabled for non-root users. To enable binding to port 80 for HTTP and 443 for HTTPS, run the command

```shell
sudo setcap cap_net_bind_service=+ep /path/to/clace_binary
```

This would be required after any new build or update of the Clace binary.

## Notes
* Please provide a valid email address in service_email. This allows you to receive expiration emails and also allows the CA to contact you if required.
* Start the configuration with staging `use_staging = true`, change to production config `use_staging = false` after ensuring that DNS and networking is working fine.
* If port 0 is used, the service will bind to any available port. Look at the stdout or logs to find the port used. Clients would have to be updated after every server restarted to point to the new port.
* Only the [TLS-ALPN](https://github.com/caddyserver/certmagic#tls-alpn-challenge) challenge is enabled in Clace. The HTTP and DNS based challenges are not supported currently.
* If Clace is running behind a load balancer, ensure that the load balancer is doing TLS pass-through. If TLS termination is done in the load balancer, then the automatic certificate management done by Clace through certmagic wil not work.