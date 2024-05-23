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

<!-- prettier-ignore --> {{< hextra/feature-card title="How does it work?" subtitle="Clace combines the functionality of a reverse proxy, a hypermedia based micro-framework and a container orchestrator (using Docker or Podman) in a single lightweight binary. Start Clace server, ensure Docker or Podman is running. New apps can be installed from GitHub source repo. Clace builds the image and starts the container lazily, on the first API call." style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="What can it be used for?" subtitle="Clace can be used to develop any containerized web app on a development machine and then deploy the app on a shared server with authentication added automatically. Apps are deployed directly from the git repo, no build step required. For example, Clace can be used to deploy Streamlit apps, adding OAuth authentication for access control across a team." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}
<br>
<br>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Container management" subtitle="Automatically build and and deploy containers, with Docker or Podman."  icon="docker" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="GitOps Workflow" subtitle="Blue-green (staged) deployments, versioning and preview environments with no infra to manage."  icon="github" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Hypermedia web apps" subtitle="Fast and lightweight backend driven apps, minimal frontend complexity."  icon="html5" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="No build step" subtitle="Backend and frontend development with no build artifacts to manage, deploy directly from the source repo."  icon="binary-off" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Lazy App Initialization" subtitle="Apps are initialized lazily, on demand: scale down to zero automatically."  icon="pause" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="Cross-platform support" subtitle="Clace runs on Linux, Windows and OSX, works with Docker and Podman"  icon="globe-alt" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.25),hsla(0,0%,100%,0));" >}}

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
