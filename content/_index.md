---
title: Clace
layout: hextra-home
---

<div class="hx-mt-6 hx-mb-6" style="background: #277A9F; background: linear-gradient(180deg, #277A9F, #359ece); color: transparent; background-clip: text; -webkit-background-clip: text;">
{{< hextra/hero-headline >}}
  App Deployment Simplified
{{< /hextra/hero-headline >}}
</div>

<div class="hx-mb-10">
{{< hextra/hero-subtitle >}}
  GitOps without the hassle.&nbsp;<br class="sm:hx-block hx-hidden"/>
  Securely deploy internal tools for teams.
{{< /hextra/hero-subtitle >}}
</div>

<div class="hx-mb-4">
{{< hextra/hero-button style="border-radius: 8px;" text="Get Started" link="docs/quickstart" >}}
{{< hextra/hero-button style="border-radius: 8px; padding: 12px 40px;" text="Demo" link="https://apps.demo.clace.io" >}}
</div>

{{< hextra/feature-grid >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="What is Clace?" icon="information-circle" subtitle="Clace™ is an application server for teams to deploy internal tools. Clace provides declarative GitOps based blue-green deployment, OAuth access controls, TLS certs & secrets management etc.<br><br> Some of the unique features of Clace are:<br>➣ Staged deployment, for code and config changes<br>➣ Atomic updates for multiple apps, all or nothing<br>➣ Declarative config sync with automated reconciliation" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="First AppServer for Containerized apps" icon="lightning-bolt" subtitle="Clace is the first AppServer built to manage containerized webapps. Clace supports:<br>➣ Deploy webapps developed in any language/framework<br>➣ Handle request routing, domain based or path based<br>➣ Manage app lifecycle imperatively (using CLI) or declaratively (through GitOps)" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore --> {{< hextra/feature-card title="How is Clace implemented" icon="beaker" subtitle="Clace is cross-platform, built as a single binary which implements the webserver and AppServer. Clace has: <br>➣ Declarative config using Starlark (python-like)<br>➣ SQLite database for metadata persistence (allowing for transactional updates)<br>➣ CLI which uses a unix domain socket for security<br>➣ GitOps driven declarative interface which works with any hosted Git service" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}
<br>
<br>

<div style="position: relative; width: 100vw; margin-left: calc(-50vw + 50%); background: #007700; color: white; justify-content: center; box-sizing: border-box; padding: 25px; font-family: 'Inter', 'Segoe UI', 'Helvetica Neue', 'Roboto', 'Arial', sans-serif;">
<div style="max-width: 800px; width: 100%; margin: 0 auto; padding: 1rem;">

<div style="font-weight: bold; margin-bottom: 20px; text-align: center;font-size: 32px; color: mintcream;">Three Steps to Declarative GitOps</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 5px; color: lightgray;">Install Clace:</div>
<div style="padding: 20px; overflow-x: auto; font-family: 'Fira Code', 'JetBrains Mono', 'SFMono-Regular', Courier, monospace;" id="code1">
curl -sSL https://clace.io/install.sh | sh
</div>
<button style="position: absolute; top: 0; right: 0; padding: 5px 10px; font-size: 12px; cursor: pointer;" onclick="copyCode('code1', this)">Copy</button>
</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 5px; color: lightgray;">Start Clace server, in a new window:</div>
<div style="padding: 20px; overflow-x: auto; font-family: 'Fira Code', 'JetBrains Mono', 'SFMono-Regular', Courier, monospace;" id="code2">
clace server start &
</div>
<button style="position: absolute; top: 0; right: 0; padding: 5px 10px; font-size: 12px; cursor: pointer;" onclick="copyCode('code2', this)">Copy</button>
</div>

<div style="position: relative;">
<div style="font-weight: bold; margin-bottom: 5px; color: lightgray;">Schedule a sync:</div>
<div style="padding: 20px; font-family: 'Fira Code', 'JetBrains Mono', 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;" title="This creates a schedule sync which runs every 15 minutes. The sync loads the config for the apps from Git, creates new apps and checks whether there are any config or code change for any of the existing apps and applies the changes." id="code3">
clace sync schedule --approve github.com/claceio/clace/examples/utils.star
</div>
<button style="position: absolute; top: 0; right: 0; padding: 5px 10px; font-size: 12px; cursor: pointer;" onclick="copyCode('code3', this)">Copy</button>
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

<br>
<br>

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
{{< hextra/feature-card title="Cross-platform" link="docs/quickstart/#installation" subtitle="Clace runs natively on Linux, Windows and OSX; use for app dev and then for app hosting"  icon="globe-alt" style="background: radial-gradient(ellipse at 50% 80%,rgba(102, 89, 186, 0.25),hsla(0,0%,100%,0));" >}}

{{< /hextra/feature-grid >}}

<br />

{{< hextra/feature-grid >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Comparison with other solutions" icon="zoom-in" subtitle="Compared to  solutions like Coolify, Dokku etc, Clace supports:<br />➣ Declarative GitOps interface, for code and for config<br/>➣ OAuth and auditing features required by teams <br/>➣ Deploying custom apps as against deploying pre-packaged services<br/><br/>Compared to heavyweight solutions built on K8s, Clace provides:<br/>➣ Single service as against glueing together CI/CD with ArgoCD/FluxCD and IDPs<br/>➣ Easy OAuth config for app access controls<br/>➣ Simple declarative config for container and web server. No YAML files, no webserver DSLs." style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

<!-- prettier-ignore -->
{{< hextra/feature-card title="Built for deploying internal tools" icon="cog" subtitle="Clace is built for teams to be able to securely develop and deploy internal tools:<br/>➣ Multiple apps can be updated atomically (all-or-nothing), no broken state after deployment failures.<br/>➣ Built for the full application management lifecycle across a team, not just the initial installation.<br/>➣ Security sand-boxing features which allow operations teams to easily manage applications through GitOps while allowing development teams to freely make code changes.<br/><br/> Clace apps can be:<br/>➣ Containerized apps deployed from source<br />➣ Autogenerated form interface for backend Actions<br/>➣ Hypermedia based apps served by Clace" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

{{< hextra/feature-card title="Common use cases" icon="users" subtitle="Clace can be used by teams to:<br/>➣  Deploy web apps built with Streamlit/Gradio/FastHTML/NiceGUI etc<br/>➣ Zero config required for most common frameworks, just specify the spec to use<br />➣ Automate internal operations using Action Jobs, replacing Jenkins and Rundeck<br/>➣ Expose web apps for internal REST APIs, replacing curl and Postman<br><br>The auth and auditing features of Clace are built for use by teams. Clace can also be used by individuals:<br/>➣ To easily run web apps in development mode locally, without having to set up a dev environment<br/>➣ To host web apps exposed publicly, with OAuth enabled or otherwise" style="background: radial-gradient(ellipse at 50% 80%,rgba(89, 67, 7, 0.15),hsla(0,0%,100%,0));" >}}

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
