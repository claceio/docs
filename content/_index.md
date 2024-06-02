---
title: Clace
layout: hextra-home
---

<div class="hx-mt-6 hx-mb-6" style="background: #277A9F; background: linear-gradient(180deg, #277A9F, #359ece); color: transparent; background-clip: text; -webkit-background-clip: text;">
{{< hextra/hero-headline >}}
  Web app deployment platform
{{< /hextra/hero-headline >}}
</div>

<div class="hx-mb-12">
{{< hextra/hero-subtitle >}}
  Easy, light-weight web app &nbsp;<br class="sm:hx-block hx-hidden"/> management for internal tools
{{< /hextra/hero-subtitle >}}
</div>

<br>
<div class="hx-mb-6">
{{< hextra/hero-button text="Get Started" link="docs/quickstart" >}}
</div>
<br>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="What is Clace?" subtitle="Clace is an Apache-2.0 licensed project building a web app development and deployment platform for internal tools. Clace allows easy and secure hosting of multiple web apps, in any language/framework, on a single machine. Clace is cross-platform (Linux/Windows/OSX) and provides a GitOps workflow for managing web apps." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="How does it work?" subtitle="Clace combines the functionality of a reverse proxy (programmable in Starlark) and a container orchestrator (using Docker or Podman) in a single lightweight binary. Start Clace server and ensure Docker or Podman is running. Apps can be installed directly from GitHub source repo. Clace builds the image and starts the container lazily, on the first API call." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="What can it be used for?" subtitle="Clace can be used on a dev machine during web app development. The app can then be deployed on a shared Clace server, adding OAuth authentication as required. Apps are deployed directly from the git repo, no build step required. For example, Clace can be used to deploy multiple Streamlit apps on a server shared across a team, using GitOps for managing CI/CD." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}
<br>
<br>

<style>
  /* Apply width 60% for screens wider than 768px */
  @media screen and (min-width: 768px) {
    .responsive-picture {
      width: 60%;
    }
  }
</style>

<picture  class="responsive-picture" style="display: block; margin-left: auto; margin-right: auto;">
  <source media="(prefers-color-scheme: dark)" srcset="https://clace.io/intro_dark.gif">
  <source media="(prefers-color-scheme: light)" srcset="https://clace.io/intro_light.gif">
  <img alt="Gif with Clace intro commands" src="https://clace.io/intro_light.gif">
</picture>

<br>
<br>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Container management" link="docs/quickstart/#containerized-applications" subtitle="Automatically build and and deploy containers, with Docker or Podman."  icon="docker" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="GitOps Workflow" link="docs/quickstart/#lifecycle-with-git" subtitle="Blue-green (staged) deployments, versioning and preview environments with no infra to manage."  icon="github" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Hypermedia web apps" link="docs/app/routing/#html-route" subtitle="Fast and lightweight backend driven apps, minimal frontend complexity."  icon="html5" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="No build step" link="docs/app/overview/#app-lifecycle" subtitle="Backend and frontend development with no build artifacts to manage, deploy directly from the source repo."  icon="binary-off" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Lazy App Initialization" link="docs/quickstart/#containerized-applications" subtitle="Apps are initialized lazily, on demand: scale down to zero automatically."  icon="pause" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Cross-platform support" link="docs/quickstart/#installation" subtitle="Clace runs on Linux, Windows and OSX, works with Docker and Podman"  icon="globe-alt" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}

<br>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Comparison with other tools" subtitle="Other tools for simplifying containerized deployment are Linux specific. They are built on top of reverse proxies (Traefik/Nginx), using container labels for routing. They are built for prod deployment only, not for dev. Adding OAuth or access control are not easy with other solutions." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Comparison with cloud services" subtitle="Cloud services like Cloud Run simplify the deployment of containerized web apps. They run outside your existing infrastructure, making it difficult to talk to your existing systems. Clace provides a similar easy to use interface. Instead of doing this as a cloud service, Clace does this on your hardware." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="How is Clace different?" subtitle="Clace is a single binary, cross-platform and can be used during development. Adding OAuth and access control and atomic updates across multiple apps is easy. Clace is built for the internal tools use-case, allowing for services to be deployed and shared across a team securely." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}
