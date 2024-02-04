---
title: "Clace"
date: 2023-10-05
cascade:
  showBreadcrumbs: true
  invertPagination: true
---

<div class="index-container">
<div class="index-item"><span style="font-size:250%;"> {{< icon "brand-html5" >}} </span>Hypermedia-driven web apps</div>
<div class="index-item"><span style="font-size:250%;"> {{< icon "brand-golang" >}} </span>Go binary, Starlark config </div>
<div class="index-item"><span style="font-size:250%;"> {{< icon "brand-github" >}} </span>GitOps flow, staged deployments</div>
<div class="index-item"><span style="font-size:250%;"> {{< icon "binary-off" >}} </span>No build step required</div>
<div class="index-item"><span style="font-size:250%;"> {{< icon "shield-lock" >}} </span>Secure app sandboxing</div>
<div class="index-item"><span style="font-size:250%;"> {{< icon "database" >}} </span>SQLite data persistence</div>
</div>

<h2>What is Clace?</h2>
Clace is an Apache-2.0 licensed project building a platform to easily develop and deploy self-hosted web applications. Clace securely runs multiple <a href="https://hypermedia.systems/hypermedia-reintroduction/">Hypermedia driven</a> web applications on a single Clace server installation.

<br>
<h2>Who is it for?</h2>
<p>
Clace can be used to easily develop and deploy hypermedia driven web applications. Clace can run web applications for use on personal machines and also host applications for access over the public internet. Clace can be used by teams to develop and deploy the UI and backend for internal applications. If you have an existing JSON based API, Clace supports building a hypermedia driven interface exposing that API. Developing a web UI for command line applications is another use-case. CRUD applications and applications which glue together APIs are good candidates for Clace applications.
<br>

<h2>How does it work?</h2>
Clace and its plugins are implemented in go. User applications are developed and configured in <a href="https://github.com/google/starlark-go">Starlark</a>, which uses Python syntax. Users of Clace do not write go code, only Starlark and HTML templates. The API routes are defined to be Hypermedia first, using HTML templates to drive the UI interactions. Templates are written using Go HTML templates. HTMX is used for server interactions. The backend code runs in a security sandbox and access to plugins need to be explicitly permitted.  There are no python or Javascript dependencies to install, no containers to create, no yaml files to manage. Application updates are done with a gitops workflow, with no-build step. Staging and preview environments are available for all apps. Clace integrates with TailwindCSS/DaisyUI for styling and has <a href="https://esbuild.github.io/">esbuild</a> built-in for <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules">ESM</a> support. Data persistence is supported to sqlite.

<br>
<h2>Installation</h2>
To install, start the service and create an app, run:
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

The app should be available at https://localhost:25223/disk_usage. `admin` is the username, use the password printed by the install script. See <a href="https://clace.io/docs/installation/#start-the-service">service startup</a> for details.
<br>

<h2>Samples</h2>
See <a href="/docs/app/overview/#examples">documentation</a> for steps to create Clace apps. See <a href="https://github.com/claceio/clace/tree/main/examples">GitHub</a> for sample application code. <a href="https://demo.clace.io/">Demo Apps</a> is an online hosted demo.

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
