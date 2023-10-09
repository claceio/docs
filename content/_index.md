---
title: "Clace"
description: "Securely develop and deploy internal web applications"
date: 2023-10-05
cascade:
  showBreadcrumbs: true
  invertPagination: false
---

<h2>What is Clace</h2>
Clace is an Apache-2.0 licensed open-source project building a secure platform to develop and deploy internal web applications. Clace provides a web application server focused on securely running multiple applications on a single installation. Clace apps are <a href="https://htmx.org/essays/spa-alternative/">Hypermedia driven</a> full stack web applications.

<br>
<h2>Who is it for</h2>
Clace can be used by individuals to host web applications for personal use. Clace can also be used by teams to securely share applications across teams. Using basic python and HTML, users can develop and share interactive applications. There are no python or Javascript dependencies to worry about, application changes can be done with no build step required.

<br>
<h2>How does it work</h2>
Clace allows applications to be configured in Starlark (subset of Python syntax). The API routes are defined to be Hypermedia first, using HTML templates to drive the UI interactions. Templates are written using Go HTML templates. HTMX is used for server interactions. The backend code runs in a security sandbox, access to plugins has to be explicitly allowed.

<br>
<h2>Examples</h2>
See <a href="/docs/app/overview/#examples">here</a> for documentation about creating simple apps. See <a href="https://github.com/claceio/clace/tree/main/examples">here</a> for the code for sample applications.

<br>
<br>

<div style="display: flex; flex-wrap: wrap; justify-content: center;  align-content: center; gap: 5px;">

<span style="font-size:200%;"> {{< icon "shield-lock" >}} </span> **Secure platform with application sandboxing**

<span style="font-size:200%;"> {{< icon "brand-html5" >}} </span> **Hypermedia first UI approach**

<span style="font-size:200%;"> {{< icon "brand-python" >}} </span> **Applications configured using Python(Starlark)**

<span style="font-size:250%;"> {{< icon "brand-golang" >}} </span> **Single binary deployment for easy installation**

<!-- <span style="font-size:200%;"> {{< icon "brand-github" >}} </span> **Github integration, for gitops workflow** !-->

</div>

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

<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-TKDPZGGPL1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-TKDPZGGPL1');
</script>
