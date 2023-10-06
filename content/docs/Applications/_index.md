---
title: "Managing Applications"
description: "Manage applications using Clace"
weight: 300
date: 2023-10-05
summary: "Installing and managing request routing across Clace applications"
---

## Request Routing

The Clace server can host multiple applications simultaneously. Each application gets a dedicated path, the application can use all sub-paths within that without conflicts with other applications.

When an application is created, a path needs to be specified and a domain can be optionally specified. Routing for application requests is done based on domain and path. The domain is the namespace within which the paths are resolved.

Consider this scenario:

- App A is installed at /utils/appA
- App B is installed at /appB
- App C is installed at the root level / for domain example.com
- App D is installed at /test for test.mydomain.com
- App E is installed at /test2 for test.mydomain.com

For every API call, the Clace server first checks whether the API call is against a domain namespace which is currently configured in Clace. If so, applications matching that domain are looked up. If no matching domain is located, then the default namespace (with no domain) is looked up.

For the above scenario:

- Requests to /utils/appA/\* for any domain other than example.com and test.mydomain.com will go to App A.
- Requests to /appB/\* for any domain other than example.com and test.mydomain.com will go to App B.
- Requests to example.com for any path will always go to App C, since it is installed at the root path.
- Requests to test.mydomain.com:/test/\* will go to App D.
- Requests to test.mydomain.com:/test2/\* will go to App E.
- Requests to test.mydomain.com for any path other than /test or /test2 will fail with a 404.

## Creating Applications

When an app is being created, a path and an optional domain need to be specified. For the above example scenario:

- No new apps can be created for example.com domain, since App C is installed at the root path.
- For the test.mydomain.con domain, no new app can be created under /test and /test2, other paths are available.
- For the default domain, /utils/appA and /appB are taken, other paths are available.
- New apps can be created under any path, including root path, for new domains and subdomains, like test.example.com.

## Notes

- The domain specified for the app is used only for routing requests. The user has to ensure that the actual DNS routing is done properly outside of Clace for the API calls to land on the Clace server.
- Using wildcard DNS entries will reduce the work required in the DNS service. So if \*.example.com points to the IP address of the Clace service, any domain based routing done in Clace will work with no further DNS configuration being required. Let's Encrypt requires DNS based challenges for wildcard certificates, [TLS-ALPN]({{< ref "networking#notes" >}}) is not supported.
- `/_clace/` at the root level and `/_clace_app/` within an app path are reserved paths, they are used by the Clace server, requests will not reach the app. This applies for all domains.
