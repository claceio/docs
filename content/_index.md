---
title: OpenRun
layout: hextra-home
---

<div class="hx-mt-6 hx-mb-6" style="background: #277A9F; background: linear-gradient(180deg, #277A9F, #359ece); color: transparent; background-clip: text; -webkit-background-clip: text;">
{{< hextra/hero-headline >}}
  App Deployment Simplified.
{{< /hextra/hero-headline >}}
</div>

<div class="hx-mb-10">
{{< hextra/hero-subtitle >}}
  Open source alternative to Google Cloud Run and AWS AppRunner.&nbsp;<br class="sm:hx-block hx-hidden"/>Easily deploy internal tools across a team.
{{< /hextra/hero-subtitle >}}
</div>

<div class="hx-mb-4">
{{< hextra/hero-button style="border-radius: 8px;" text="Get Started" link="docs/quickstart" >}}
{{< hextra/hero-button style="border-radius: 8px; padding: 12px 40px;" text="Demo" link="https://apps.demo.openrun.dev" >}}
</div>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="What is OpenRun?" icon="information-circle" subtitle="OpenRun™ is an application server for teams to deploy internal tools. OpenRun provides declarative GitOps based blue-green deployment, OAuth access controls, TLS certs & secrets management etc.<br><br> Some of the unique features of OpenRun are:<br>➣ Staged deployment, for code and config changes<br>➣ Atomic updates for multiple apps, all or nothing<br>➣ Declarative config sync with automated reconciliation" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="First AppServer for Containerized apps" icon="lightning-bolt" subtitle="OpenRun is the first AppServer built to manage containerized webapps. OpenRun supports:<br>➣ Deploy webapps developed in any language/framework<br>➣ Handle request routing, domain based or path based<br>➣ Manage app lifecycle imperatively (using CLI) or declaratively (through GitOps)" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="How is OpenRun implemented" icon="beaker" subtitle="OpenRun is cross-platform, built as a single binary which implements the webserver and AppServer. OpenRun has: <br>➣ Declarative config using Starlark (python-like)<br>➣ SQLite database for metadata persistence (allowing for transactional updates)<br>➣ CLI which uses a unix domain socket for security<br>➣ GitOps driven declarative interface which works with any hosted Git service" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

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
<button title="Copy" style="position: absolute; top: 5px; right: 5px; padding: 10px 10px 1px 10px; font-size: 12px; cursor: pointer;" onclick="copyCode('code1', this)">⧉</button>
</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 10px; color: lightgray;">Start OpenRun server (in a new window):</div>
<div style="padding-inline: 10px; padding-top: 5px; padding-bottom: 20px; font-size: 14px; font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;" id="code2">
openrun server start &
</div>
<button title="Copy" style="position: absolute; top: 5px; right: 5px;  padding: 10px 10px 1px 10px; font-size: 12px; cursor: pointer;" onclick="copyCode('code2', this)">⧉</button>
</div>

<div style="font-weight: bold; margin-top: 20px; margin-bottom: 20px; text-align: center;font-size: 24px; color: mintcream;">GitOps in One Command</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 10px; color: lightgray;">Schedule a sync:</div>
<div style="padding-inline: 10px; padding-top: 5px; padding-bottom: 20px; font-size: 14px; font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;" id="code3">
openrun sync schedule --approve --promote github.com/openrundev/openrun/examples/utils.star
</div>
<button title="Copy" style="position: absolute; top: 5px; right: 5px; padding: 10px 10px 1px 10px; font-size: 12px; cursor: pointer;" onclick="copyCode('code3', this)">⧉</button>
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

<div style="height: 20px;"></div>

<div  style="position:relative; width:100%; max-width:560px; padding-bottom:5%; margin:0 auto; overflow:hidden;">
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/YrWNz4JQ6p0?si=tnjma2uqBp2OrE7m" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

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
{{< hextra/feature-card title="Comparison with other solutions" icon="zoom-in" subtitle="Compared to  solutions like Coolify, Dokku etc, OpenRun supports:<br />➣ Declarative GitOps interface, for code and for config<br/>➣ OAuth and auditing features required by teams <br/>➣ Deploying custom apps as against deploying pre-packaged services<br/><br/>Compared to heavyweight solutions built on K8s, OpenRun provides:<br/>➣ Single service as against glueing together CI/CD with ArgoCD/FluxCD and IDPs<br/>➣ Easy OAuth config for app access controls<br/>➣ Simple declarative config for container and web server. No YAML files, no webserver DSLs." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Built for deploying internal tools" icon="cog" subtitle="OpenRun is built for teams to be able to securely develop and deploy internal tools:<br/>➣ Multiple apps can be updated atomically (all-or-nothing), no broken state after deployment failures.<br/>➣ Built for the full application management lifecycle across a team, not just the initial installation.<br/>➣ Security sand-boxing features which allow operations teams to easily manage applications through GitOps while allowing development teams to freely make code changes.<br/><br/> OpenRun apps can be:<br/>➣ Containerized apps deployed from source<br />➣ Autogenerated form interface for backend Actions<br/>➣ Hypermedia based apps served by OpenRun" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< hextra/feature-card title="Common use cases" icon="users" subtitle="OpenRun can be used by teams to:<br/>➣  Deploy web apps built with Streamlit/Gradio/FastHTML/NiceGUI etc<br/>➣ Zero config required for most common frameworks, just specify the spec to use<br />➣ Automate internal operations using Action Jobs, replacing Jenkins and Rundeck<br/>➣ Expose web apps for internal REST APIs, replacing curl and Postman<br><br>The auth and auditing features of OpenRun are built for use by teams. OpenRun can also be used by individuals:<br/>➣ To easily run web apps in development mode locally, without having to set up a dev environment<br/>➣ To host web apps exposed publicly, with OAuth enabled or otherwise" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

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
