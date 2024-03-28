---
title: "Clace"
date: 2023-10-05
cascade:
  showBreadcrumbs: true
  invertPagination: true
---

<div class="index-container">
<div class="index-item"><span style="font-size:250%;"> {{< icon "brand-github" >}} </span><b>GitOps Workflow</b> - Staged deployments, versioning and preview environments with no infra to manage</div>
<div class="index-item"><span style="font-size:250%"> {{< icon "binary-off" >}} </span><b>No build step</b> - Backend and frontend development with no build step, the source repo is the deployment artifact</div>
<div class="index-item"><span style="font-size:250%"> {{< icon "brand-html5" >}} </span><b>Hypermedia web apps</b> - Fast and lightweight backend driven apps, minimal frontend complexity</div>
<div class="index-item"><span style="font-size:250%"> {{< icon "brand-golang" >}} </span><b>Go binary, Starlark config</b> - Performance and stability of Go, easy Python like backend config with no dependencies</div>
<div class="index-item"><span style="font-size:250%"> {{< icon "shield-lock" >}} </span><b>Secure app sandboxing</b> - Apps runs in security sandbox, apply app code updates confidently</div>
<div class="index-item"><span style="font-size:250%"> {{< icon "database" >}} </span><b>SQLite data persistence</b> - Easy access to SQLite based app data persistence, with auto-schema management</div>
</div>

<h2>What is Clace?</h2>
Clace is an Apache-2.0 licensed project building a platform to easily develop and deploy self-hosted web applications. Clace securely runs multiple <a href="https://hypermedia.systems/hypermedia-reintroduction/">Hypermedia driven</a> web applications on a single Clace server installation. Clace combines functionality usually provided by multiple services: web server (domain/path based routing, TLS certs, static file serving), application server (API handling, backend and frontend logic) and deployment infrastructure (isolation across apps, versioning and staged deployments, gitops deployment). For web application development, Clace provides all of that functionality in a single lightweight binary.

<br>
<h2>What can it do?</h2>
<p>
Clace can be used to easily develop and deploy hypermedia driven web applications which are secure and portable. Clace can run web apps for personal use and also host applications for access over the public internet. Clace can be used by teams to host internal applications. Clace supports building a hypermedia driven web interface for an existing API's, a backend-for-frontend type pattern. Developing a web UI for command line applications is another use-case. CRUD applications and applications which glue together backend APIs are good candidates for Clace apps.
<br>

<h2>How does it work?</h2>
Clace and its plugins are implemented in go. User applications are developed and configured in <a href="https://github.com/google/starlark-go">Starlark</a>, which uses a python inspired syntax. Users of Clace write only Starlark and HTML templates. The backend code runs in a security sandbox and access to plugins need to be explicitly permitted. The API routes are defined to be Hypermedia first, using template partials to drive the UI interactions. <a href="https://htmx.org/">HTMX</a> is used for server interactions from the UI.

There are no Python or Javascript dependencies to install, no containers to create, no yaml files to manage. Application updates are done with a gitops workflow, with no-build step. Staging and preview environments are available for apps. Clace integrates with TailwindCSS/DaisyUI for UI styling and has <a href="https://esbuild.github.io/">esbuild</a> built-in for <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules">ESM</a> support. Data persistence to sqlite is supported using a document store interface. Clace manages request routing and TLS certificates creation and renewal, so a separate web server is not required.

<h2>Installation</h2>
To install, start the service and create an app on <b>Linux or OSX</b>, run:
<br>

<div class="index-code" style="text-align: left;">
<pre class="index-pre"><code><span class="index-no-copy">$</span> curl -L https://clace.io/install.sh | sh
# Note down the generated password
<span class="index-no-copy">$</span> source $HOME/clhome/bin/clace.env
<span class="index-no-copy">$</span> clace server start & <br>
# Any new app can be installed by running
<span class="index-no-copy">$</span> clace app create --approve /disk_usage github.com/claceio/clace/examples/disk_usage/ </code>
</pre>
</div>

<br>
To install Clace on <b>Windows</b>, run:

<div class="index-code" style="text-align: left;">
<pre class="index-pre"><code><span class="index-no-copy">$</span> pwsh -Command "iwr https://clace.io/install.ps1 -useb | iex" </code>
</pre>
</div>

Use `powershell` if `pwsh` is not available. Start a new command window (to get the updated ENV values) and run:

<div class="index-code" style="text-align: left;">
<pre class="index-pre"><code><span class="index-no-copy">$</span> clace server start </code>
</pre>
</div>

To install apps on Windows, use the same command as Linux/OSX. To install a bookmark manager app, run:

<div class="index-code" style="text-align: left;">
<pre class="index-pre"><code><span class="index-no-copy">$</span> clace app create --approve /book github.com/claceio/apps/utils/bookmarks </code>
</pre>
</div>

The disk usage app is available at <a href="https://localhost:25223/disk_usage">https://localhost:25223/disk_usage</a> (use port 25222 for HTTP). `admin` is the username, use the password printed by the install script. The bookmark manager is available at <a href="https://localhost:25223/book">https://localhost:25223/book</a>.

See <a href="https://clace.io/docs/installation/#start-the-service">here</a> for more details about installation.
<br>

<h2>Samples</h2>
See <a href="/docs/app/overview/#examples">documentation</a> for steps to create Clace apps. See <a href="https://github.com/claceio/clace/tree/main/examples">examples</a> and <a href="https://github.com/claceio/apps">apps repo</a> for sample applications. See <a href="https://demo.clace.io/">here</a> for an online demo showing some Clace apps.

See <a href="/docs/quickstart">quick start</a> for details on getting started with Clace.

<br>
<br>
<br>

<!-- Begin Mailchimp Signup Form -->
<!--link href="//cdn-images.mailchimp.com/embedcode/classic-071822.css" rel="stylesheet" type="text/css"-->
  <div id="mc_embed_signup">
    <form action="https://clace.us21.list-manage.com/subscribe/post?u=3e38430549570438cbc8b7513&amp;id=57d9eeea29&amp;f_id=00afa8e1f0" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank">
     <div style="display: flex; align-items: center; justify-content: center;">
	<label for="mce-EMAIL" ><b>Sign up for email updates</b></label>
	<input type="email" placeholder="Enter your email" name="EMAIL" id="mce-EMAIL" style="margin-left: 10px; border: 1px solid #000" required>
	<div aria-hidden="true" id="mce-responses" class="clear foot" >
		<div class="response" id="mce-error-response" style="display:none"></div>
		<div class="response" id="mce-success-response" style="display:none"></div>
	</div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
        <input aria-hidden="true" type="hidden" name="b_3e38430549570438cbc8b7513_57d9eeea29"  value="">
        <button class="rounded-full" type="submit" name="subscribe" id="mc-embedded-subscribe" style="margin-left: 10px; background-color: #4CAF50; color: white; border: none; padding: 4px 10px; cursor: pointer;">Subscribe</button>
     </div>
    </form>
  </div>
<!--End mc_embed_signup-->
