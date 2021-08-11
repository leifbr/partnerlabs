Exercise 3 - Mitigating BoT Attacks
===================================

Mitigating Bots using a Bot profile (v14.1)
-------------------------------------------

Objectives:

-  Set up a Dos Profile using the “Balanced” profile as the profile
   template.

-  Create a BoT logging profile.

-  Attack the site using BoTs (curl, ab, OWASP Zap)

-  Review the results in the BoT Dashboard and logs.

-  Estimated time for completion: **15 minutes**

Set up the Bot profile
~~~~~~~~~~~~~~~~~~~~~~

In version 14.1 Bot protection was separated from the DoS profile and
give its own profile. In the section you will configure a BoT protection
profile, create a logging profile and attach the Bot profile and logging
profile to the virtual server.

You will need to create a new BoT profile before you can configure DoS
mitigation.

1. Go to **Security ›› Bot Defense : Bot Defense Profiles** here you can
   see a number of pre-defined BoT profiles. Select **Create**. Move
   down the configuration settings on the **Bot Profile Configuration**
   sidebar.

   a. Note the **Note**. Because we haven’t set up DNS on the BIG-IP,
      BoT protection will not be able to determine if benign Bots, such
      as GoogleBots, are being impersonated.

      i. The BIG-IP will do DNS lookups to determine the appropriate IP
         addressing of certain BoTs.

   b. Under **General Settings** select the **Advanced** menu in the
      upper right corner.

      i.   Profile Name: **app_bot_protection**

      ii.  Enforcement Mode: **Blocking**

           1. For our purposes we will go straight to Blocking mode

      iii. Profile Template: Balanced

           1. Select the **Learn more** link to see the difference in
              the default profiles.

      iv.  Enforcement Readiness Period: 0 days

           1. Again to speed up the process

..

   .. image:: /_static/advwaf/image36.png
      :align: center
      :width: 500

v. Everything else can be left at the defaults, but feel free to review
   the different option

c. **Mitigation Settings** can also be left at the current defaults. If
      you had left the **Enforcement** **Mode** at **Transparent** the
      mitigation enforcement cases at the bottom would have defaulted to
      **Disabled**. Click the question marks for more information on the
      cases.

d. **Microservice Protection** is left at the defaults.

e. **Browser Verification** can be left at the defaults. Settings here
      will determine, if and when we will challenge client browser to
      determine if it actually a BoT.

f. **Mobile Applications** can be left at the defaults, but this section
      works in conjunction with the Anti-Bot mobile SDK to determine if
      mobile devices have been compromised.

g. **Signature Enforcement** will be left at default. This allows you
      more granular and quicker enforcement of BoT signatures.

h. **Whitelist** will be left at the default.

1. Select **Save** in the upper right corner.

.. _section-1:

Create a BoT Logging profile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Like with Advance WAF aka ASM you will create a logging profile to
capture DoS events.

1. Go to **Security ›› Event Logs : Logging Profiles** and select
   **Create**. Name your profile **bot_logger**.

   a. You could also modify the **asm_allrequests** logging profile to
      include BoT logging, but a separate could be used on multiple
      virtual servers where only BoT protection is required.

   b. Check **Bot Defense** enable box.

      i.   In the **DoS Protection** tab enable the **Local Publisher**.

      ii.  In the **Bot Defense** tab check **ALL** the boxes.

      iii. Hit **Create**.

..

   .. image:: /_static/advwaf/image37.png
      :align: center
      :width: 500

Add the BoT profile to a virtual server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   The DOS profile has only Bot Signatures enabled.

1. Go to **Local Traffic > Virtual Servers > Virtual Server List** and
   select **vs_hackazon_http**. Under the **Security** tab on the top
   bar select **Policies**.

2. Enable the **BoT Defense Profile** and select the
   **app_bot_protection** profile.

3. Add **bot_logger** to the **Log Profile**.

4. For purposes of this lab, **Disable** the **Application Security
   Policy** and remove **asm_allrequests** from the **Log Profile.**

..

   .. image:: /_static/advwaf/image38.png
      :align: center
      :width: 500

1. Finally, select **Update**.

Attack with BoTs and observe the results
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First let’s use an **HTTP Library (Benign)** tool, **curl**. Remember
just because tools are in the **Benign** category doesn’t mean they
can’t be used for nefarious purposes. Reporting will at allow you to
know that these tools are being used against your site.

1. From a terminal window on the jumpbox run the following several
   times:

curl http://hackazon.f5demo.com

   In the **Security ›› Event Logs : Bot Defense : Requests** you should
   see entries similar to this:

.. image:: /_static/advwaf/image39.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML1996f7f9.PNG
   :align: center
   :width: 500

   The BoT signature and category are logged and the BoT is allowed
   because the **Untrusted Bot** category is set to **Alarm** only.

   In the **Security ›› Event Logs : Bot Defense : Bot Traffic** screen
   it may take a few minutes for the data to show up, but you should see
   something similar to the following:

   .. image:: /_static/advwaf/image40.png
      :align: center
      :width: 500

This time we will use the apache bench (ab) BoT from the **DOS Tools
(Malicious)** category. The BoT was originally design for benchmark
testing but is mostly used for those nefarious purposes I spoke of
earlier.

1. From a terminal window on the jumpbox run the following:

ab -c 10 -n 10 -r http://hackazon.f5demo.com/

In the DoS event log you can see this BoT was **Denied** (blocked) by
sending a TCP reset immediately to the client.

.. image:: /_static/advwaf/image41.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML199e6d75.PNG
   :align: center
   :width: 500

If you go back to the **Bot Traffic** dashboards you will see the new
attacks. If you select **View Detected Bots** at the bottom you will get
a summary of the incidents.

.. image:: /_static/advwaf/image42.png
   :align: center
   :width: 500

You are now going to use the OWASP ZAP tool to run a spider bot attack
against the Hackazon website.

1. From the **Applications Menu** in the upper left-hand corner of the
   jumpbox go to **OWASP > Proxies > ZAP**.

2. Once ZAP is open, click on **Start** when asked **Do you want to
   persist the ZAP session**.

3. In the **Quick Start** tab, in the **URL Attack** box, enter
   http://hackazon.f5demo.com and hit the **Attack** button\ **.**

..

   .. image:: /_static/advwaf/image43.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTMLaa9baf9.PNG
      :align: center
      :width: 500


1. Once the attack has started a **Spider** tab should appear in the
   bottom ZAP window. You will see ZAP attempting to crawl the web site.
   **T**\ he attack will be short lived.

.. image:: /_static/advwaf/image44.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML19aa6983.PNG
   :align: center
   :width: 500

Without Bot protection it would have scan the site.

.. image:: /_static/advwaf/image45.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTMLaafc85a.PNG
   :align: center
   :width: 500

1. Check the Bot Requests you’ll find Non-browser presenting as Internet
   Explorer request. Go to **All Details** and check out the attack and
   how BIG-IP detected it.

Now let’s see how BIG-IP challenges Bots that don’t match up to the
signatures. We already saw some of this with OWASP Zap, but here you
will see the BIG-IP challenge the client to prove it’s not a Bot.

1. Go to Bot Request, find a curl request and look at the **Request**
   section. In it you will find the User-Agent set to curl/7.52.1

.. image:: /_static/advwaf/image46.png
   :align: center
   :width: 500

1. That makes it kind of easy to detect, but what if we changed the
   User-Agent to a legitimate browser. Could the BIG-IP still detect it?

   a. Run the following command from a terminal window:

..

   curl -A "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X;
   en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2
   Mobile/8J2 Safari/6533.18.5" http://hackazon.f5demo.com

The resulting request failed, and you can see the obfuscated code and
the BIG-IP block page and support ID at the bottom. Even though the
signature is allowed, curl cannot meet the javascript challenge
(returning ASM cookie, prefixed by TS, with the javascript results)
presented it. Check the BoT Request log for the results showing the Bot
was challenged and we sent a Captcha.

.. image:: /_static/advwaf/image47.png
   :align: center
   :width: 500

.. image:: /_static/advwaf/image48.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML19ba8c20.PNG
   :align: center
   :width: 500

1. On you Bot Traffic dashboard you can see the Browser Masquerading
   category

.. image:: /_static/advwaf/image49.png
   :align: center
   :width: 500
