---
title: OpenRun
layout: hextra-home
---

<div class="hx:mb-4" style="background: #277A9F; background: linear-gradient(180deg, #277A9F, #359ece); color: transparent; background-clip: text; -webkit-background-clip: text;">
{{< hextra/hero-headline >}}
  App Deployment Simplified.
{{< /hextra/hero-headline >}}
</div>

<div class="hx:mb-6">
{{< hextra/hero-subtitle >}}
  Open source alternative to Google Cloud Run and AWS App Runner.&nbsp;<br class="hx:sm:block hx:hidden"/>Easily deploy internal tools across a team.
{{< /hextra/hero-subtitle >}}
</div>

<div class="hx:mb-4">
{{< hextra/hero-button style="border-radius: 8px;" text="Get Started" link="docs/quickstart" >}}
{{< hextra/hero-button style="border-radius: 8px; padding: 12px 40px;" text="Demo" link="https://apps.demo.clace.io" >}}
</div>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="What is OpenRun?" icon="information-circle" subtitle="OpenRun™ is a open source alternative to Google Cloud Run and AWS App Runner. OpenRun makes it easy to deploy applications built in frameworks like Streamlit/Gradio/FastHTML/NiceGUI etc.<br><br>OpenRun provides declarative GitOps based blue-green deployment, OAuth access controls, TLS certs & secrets management. It has features required by teams to deploy internal tools.<br><br> " style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="OpenRun Features" icon="lightning-bolt" subtitle="Some of the unique features of OpenRun are:<br>➣ Domain based or path based routing, with auto-TLS<br>➣ Scale idle apps down to zero<br>➣ Staged deployment, for code and config changes<br>➣ Atomic (all or nothing) updates across apps<br>➣ Declarative config sync with automated reconciliation<br>➣ OAuth and OpenID based access controls for apps<br>➣ Zero-config deployment for webapps developed in most common languages/frameworks" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="How it Works" icon="beaker" subtitle="OpenRun is a single binary, running as a service which implements webserver and AppServer functionality. OpenRun has:<br>➣ Declarative config using Starlark (python-like)<br>➣ Single node deployment with SQLite database<br>➣ Multi node deployment with an external Postgres<br>➣ Push or pull based GitOps for app management<br>➣ Kubernetes based deployment option (coming soon)" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}

<div style="height: 20px;"></div>

<div style="position: relative; width: 100vw; margin-left: calc(-50vw + 50%); background: #007700; color: white; justify-content: center; box-sizing: border-box; padding: 25px; font-family: 'Inter', 'Segoe UI', 'Helvetica Neue', 'Roboto', 'Arial', sans-serif;">
<div style="max-width: 800px; width: 100%; margin: 0 auto; padding: 1rem;">

<div style="font-weight: bold; margin-bottom: 20px; text-align: center;font-size: 24px; color: mintcream;">Installation</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 10px; color: lightgray;">Install OpenRun:</div>
<div style="padding-inline: 10px; padding-top: 5px; padding-bottom: 20px; font-size: 14px; font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;" id="code1">
curl -sSL https://openrun.dev/install.sh | sh
</div>
<button title="Copy" style="position: absolute; top: 5px; right: 5px; padding: 10px 10px 1px 10px; font-size: 14px; cursor: pointer;" onclick="copyCode('code1', this)">⧉</button>
</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 10px; color: lightgray;">Start OpenRun server (in a new window):</div>
<div style="padding-inline: 10px; padding-top: 5px; padding-bottom: 20px; font-size: 14px; font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;" id="code2">
openrun server start &
</div>
<button title="Copy" style="position: absolute; top: 5px; right: 5px;  padding: 10px 10px 1px 10px; font-size: 14px; cursor: pointer;" onclick="copyCode('code2', this)">⧉</button>
</div>

<div style="font-weight: bold; margin-top: 20px; margin-bottom: 20px; text-align: center;font-size: 24px; color: mintcream;">GitOps in One Command</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 10px; color: lightgray;">Schedule a sync:</div>
<div style="padding-inline: 10px; padding-top: 5px; padding-bottom: 20px; font-size: 14px; font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;" id="code3">
openrun sync schedule --approve --promote github.com/openrundev/openrun/examples/utils.star
</div>
<button title="Copy" style="position: absolute; top: 5px; right: 5px; padding: 10px 10px 1px 10px; font-size: 14px; cursor: pointer;" onclick="copyCode('code3', this)">⧉</button>
</div>

<div style="margin-top: 5px; margin-bottom: 5px; text-align: center;font-size: 16px; color: lightgray;">Starts a background sync which automatically creates new apps and updates existing apps, reading latest app config and code from Git.</div>

</div>
</div>

<script>
function copyCode(codeId, buttonElem) {
    const code = document.getElementById(codeId).textContent;
    navigator.clipboard.writeText(code).then(() => {
        const originalText = buttonElem.textContent;
        buttonElem.textContent = 'Copied!';
        setTimeout(() => {
            buttonElem.textContent = originalText;
        }, 2000);
    }).catch(err => {
        console.error('Copy failed', err);
    });
}
</script>

<!--div style="height: 20px;"></div>

<div  style="position:relative; width:100%; max-width:560px; padding-bottom:5%; margin:0 auto; overflow:hidden;">
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/YrWNz4JQ6p0?si=tnjma2uqBp2OrE7m" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div-->

<div style="height: 20px;"></div>

{{< hextra/feature-grid >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Container management" link="docs/quickstart/#containerized-applications" subtitle="Build and deploy containerized web apps, with Docker or Podman."  icon="docker" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="GitOps Workflow" link="docs/quickstart/#lifecycle-with-git" subtitle="Blue-green (staged) deployments, versioning and preview environments with no infra to manage."  icon="github" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Automatic GitOps Sync" link="/docs/applications/overview/#automated-sync" subtitle="Easily setup scheduled Git sync with pull based updates"  icon="sparkles" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Scale down to zero" link="/docs/container/overview/" subtitle="Apps are initialized lazily, on demand: scale down to zero automatically."  icon="pause" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Autogenerated web-apps" link="docs/actions" subtitle="Auto generate simple web interfaces for existing CLI tools and API endpoints."  icon="html5" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Cross-platform" link="docs/quickstart/#installation" subtitle="OpenRun runs natively on Linux, Windows and OSX; use for app dev and then for app hosting"  icon="globe-alt" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}

<div style="height: 20px;"></div>

{{< hextra/feature-grid >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Comparison with other self-hosted solutions" icon="zoom-in" subtitle="Compared to solutions like Coolify, CapRover, Dokploy, Dokku etc, OpenRun has:<br />➣ Declarative GitOps interface, for code and for config. New apps can be added through config updates in git, without CLI commands or UI operations<br/>➣ OAuth access controls for apps and API audit logging features required by teams for internal tools<br />➣ Single binary, Docker/Podman is only dependency, does not depend on a third party webserver like Traefik/Nginx<br/><br/>OpenRun is built as a self-hosted Google Cloud Run/AWS App Runner alternative as against full PaaS solution. OpenRun does not support deploying auxiliary services like databases and there is no Docker Compose support." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Comparison with Cloud services" icon="cog" subtitle="Compared to Cloud services like Google Cloud Run and AWS App Runner, OpenRun provides:<br />➣ Easy app provisioning on your hardware, in your network, enabling network level security controls<br/>➣ Better cost management for apps requiring custom hardware or higher instance limits<br />➣ Add OAuth/OpenID access controls to apps, with zero app level changes<br/><br/> Compared to heavyweight solutions built on Kubernetes, OpenRun provides:<br/>➣ Single service as against glueing together services like ArgoCD/FluxCD for CI/CD, IDP for app management etc<br/>➣ Simple declarative config, no YAML files, no webserver DSLs." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< hextra/feature-card title="Common use cases" icon="users" subtitle="OpenRun can be used by teams to:<br/>➣  Deploy web apps with zero config required for most common frameworks like Streamlit/Gradio/FastHTML/NiceGUI etc.<br />➣ Replace Jenkins/Rundeck jobs, using OpenRun Actions for automating operational scripts<br/>➣ Expose web apps for internal REST APIs, replacing manual curl commands<br><br>While the auth and auditing features of OpenRun are built for use by teams, OpenRun can also be used by individuals for:<br/>➣ Zero-config dev env setup locally<br/>➣ Host web apps exposed publicly, with OAuth enabled or otherwise" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}

<div style="height: 20px;"></div>

<style>
  /* Apply width 60% for screens wider than 768px */
  @media screen and (min-width: 768px) {
    .responsive-picture {
      width: 60%;
    }
  }
</style>

<video controls muted class="responsive-picture" style="display: block; margin-left: auto; margin-right: auto;">
  <source media="(prefers-color-scheme: dark)" src="https://openrun.dev/demo_dark.mp4" type="video/mp4">
  <source media="(prefers-color-scheme: light)" src="https://openrun.dev/demo_light.mp4" type="video/mp4">
</video>
<br>
