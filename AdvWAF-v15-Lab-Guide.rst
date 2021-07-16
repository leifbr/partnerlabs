AdvWAF-v14.x Updates

Lab Guide

Participant Hands-on Lab Guide

.. image:: media/image1.png
   :width: 1.93667in
   :height: 0.61667in

Last Updated: *7/16/15*

©2015 F5 Networks, Inc. All rights reserved. F5, F5 Networks, and the F5
logo are trademarks of F5 Networks, Inc. in the U.S. and in certain
other countries. Other F5 trademarks are identified at f5.com.

Any other products, services, or company names referenced herein may be
trademarks of their respective owners with no endorsement or
affiliation, express or implied, claimed by F5.

**Table of Contents**

`Lab Network Overview 2 <#section>`__

`Accessing the lab environment 4 <#accessing-the-lab-environment>`__

`Exercise 1 – ASM Policy Creation and Logging
6 <#exercise-1-asm-policy-creation-and-logging>`__

`Create ASM Policy 6 <#create-asm-policy>`__

`Creating Application Security Policy
7 <#creating-application-security-policy>`__

`Enable Application Security Logging
9 <#enable-application-security-logging>`__

`Exercise 2 – Policy Staging 14 <#exercise-2-policy-staging>`__

`Understanding Staging 14 <#understanding-staging>`__

`Perform a SQL Injection 14 <#perform-a-sql-injection>`__

`Perform a Cross Site Scripting attack
16 <#perform-a-cross-site-scripting-attack>`__

`Signature Staging 18 <#signature-staging>`__

`Exercise 3 - Mitigating BoT Attacks
22 <#exercise-3---mitigating-bot-attacks>`__

`Mitigating Bots using a Bot profile (v14.1)
22 <#mitigating-bots-using-a-bot-profile-v14.1>`__

`Set up the Bot profile 22 <#set-up-the-bot-profile>`__

`Create a BoT Logging profile 23 <#create-a-bot-logging-profile>`__

`Add the BoT profile to a virtual server
24 <#add-the-bot-profile-to-a-virtual-server>`__

`Attack with BoTs and observe the results
24 <#attack-with-bots-and-observe-the-results>`__

`Exercise 4 – Protecting Credentials with DataSafe
28 <#exercise-4-protecting-credentials-with-datasafe>`__

`Exercise 1 – Review and Attack the Login Page
28 <#exercise-1-review-and-attack-the-login-page>`__

`Task 1 – Review Form Fields with the Developer Tools
28 <#task-1-review-form-fields-with-the-developer-tools>`__

`Task 2 – Review Methods for Stealing Credentials
28 <#task-2-review-methods-for-stealing-credentials>`__

`Task 3 – Perform a Form Field “Web Inject”
29 <#task-3-perform-a-form-field-web-inject>`__

`Exercise 2 – Review and Configure DataSafe Components
31 <#exercise-2-review-and-configure-datasafe-components>`__

`Task 1 – DataSafe Licensing and Provisioning
31 <#task-1-datasafe-licensing-and-provisioning>`__

`Exercise 3 – Testing DataSafe Protection
33 <#exercise-3-testing-datasafe-protection>`__

`Task 1 – Review the Protected Hackazon Login Page
33 <#task-1-review-the-protected-hackazon-login-page>`__

*
*

Lab Network Overview
====================

Each student will have a BIG-IP VE environment with IP addressing as
below:

.. image:: media/image2.jpg
   :width: 6.5974in
   :height: 6.73203in

Accessing the lab environment
=============================

a. Open a browser and go to the link assign to you b (where **X** is
      your student number)

b. Look for the **xubuntu-jumpbox-vxx**. You will use the xubuntu
      jumpbox for all the labs. (see below)

..

   .. image:: media/image3.png
      :width: 3.775in
      :height: 2.87104in

c. You can click on **RDP** to RDP to the Xubuntu jumpbox or you can
   select the **CONSOLE** link and access the jumpbox via your browser.
   **The CONSOLE link requires you turn off pop-up blockers.**

..

   .. image:: media/image4.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML230ba94c.PNG
      :width: 3.36587in
      :height: 3.04167in

1. Open the Chrome browser and log into the BIG-IP GUI to verify the
   BIG-IP is up.

   a. Go to **https://10.1.1.245**

      i.  User: **admin**

      ii. Password: **admin**

2. Now you will perform an initial configuration via command line.

   a. Open a terminal window from the taskbar at the bottom.

      i.   Log in to the BIG-IP using the command: **ssh
           root@10.1.1.245**

      ii.  The password is **default.**

      iii. At the BIG-IP prompt, enter **tmsh**

           1. This will place you in the BIG-IP command line mode.

   b. In your browser, open then the **Lab Guides** link on the
      bookmarks bar in a new tab/window.

   c. Open the **AdvWAF Base Setup.txt** file and review the commands.

   d. Copy all the commands between **# BEGIN COPY - Lab prep** and **#
      END COPY - Lab prep**

   e. Paste the commands into the terminal window at the **tmsh**
      prompt.

   f. **The BIG-IP will take several minutes to come back online.**

      i. Good time for a bathroom break. Smoke ‘em if you got ‘em.

3. Verify the virtual server and web site are up and running.

   a. Go to **Local Traffic >> Network Map**. There should be two
      virtual servers and all should be available (green).

   b. Open up the Firefox browser. Go to http://hackazon.f5demo.com and
      https://hackazon.f5demo.com

   c. 

Exercise 1 – ASM Policy Creation and Logging
============================================

Create ASM Policy
-----------------

Objectives:

-  View the v14.x policy building GUI interface

-  Create a security policy using automatic policy building

-  Enable application security logging profile

-  Estimated time for completion: **20 minutes**

This lab will demonstrate how to create and build a security policy
using automatic policy building.

Before you begin, the penetration testing tool, OWASP ZAP, has already
been run against the website and the results have been saved. Let’s take
a look at the test to see the results. You will use this information to
plug a few holes.

1. From the Applications Menu in the upper left-hand corner of the
   jumpbox go to **OWASP > Proxies > ZAP**.

2. Once ZAP is open, click on **Start** when asked Do you want to
   persist the ZAP session.

3. Under **File** select **Open Session** and select
   **hackazon-zap-session.session.**

4. Once the session is loaded, go to the **Alerts** tab, you will see a
   number of vulnerabilities found.

..

   .. image:: media/image5.png
      :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTMLe2109f4e.PNG
      :width: 4.30972in
      :height: 1.85694in

a. We will be focusing on the CrossSite Scripting (XSS) and SQL
   Injection vulnerabilities discovered specifically, on the Search page
   and User Login page.

   i. If you expand the tabs you can see the vulnerabilities found.
      Click on the page to get more detail.

Creating Application Security Policy
------------------------------------

1. **Guide Configurations** is only available for Advanced WAF, so we
   will build our policies using the Create New Policy wizard.

2. On the Main tab, click **Security** > **Application Security** >
   **Security Policies**. The Active Policies screen opens.

3. Click the **Create..** button. As you can see, security policy setup
   is done on a single page.

.. image:: media/image6.png
   :width: 4.29691in
   :height: 3.09898in

4. Enter the following information:

   a. Name: **hackazon_asm**

   b. Policy Type: **Security**

   c. Policy Template: **Comprehensive**

   d. Virtual Server: **vs_hackazon_http (HTTP)**

..

   If you are familiar with pre 13.x ASM you may have noted there is no
   longer an “Enhanced” policy selection. Also, if you look in the upper
   right-hand corner you will see **Basic** and **Advance** selections.

5. Select **Advanced** and read the descriptions of the configuration
   items and modify the following configuration items.:

   a. Application Language: **Unicode (utf-8)**

   b. Enforcement Mode: **Transparent**

   c. Server Technologies: <Select **Apache Tomcat**, **MySQL**,
      **Unix/Linux**>

   d. Trusted IP: **10.1.10.0/255.255.255.0**

   e. Policy Builder Learning Speed: **Fast**

If you recall, **Server Technologies** assigns attack signatures base on
the selected technologies, but can also learn new technologies based on
HTTP Requests/Responses. The Hackazon website user PHP, which you did
not enter. Later you will see if BIG-IP discovers PHP and adds the
attack signatures.

You also made your jumpbox a “trusted” client and set the learning speed
to fast, so the policy will build quickly.

When you are done your **Advance** configuration items should look
something like this:

.. image:: media/image7.png
   :width: 5.7865in
   :height: 3.57294in

6. Review your security policy and click **Create Policy** at the upper
   left. It may take a few minutes. Notice you have a number of new
   things you can do with your security policy.

.. image:: media/image9.png
   :width: 5.849in
   :height: 2.95315in

Enable Application Security Logging
-----------------------------------

1. In the Configuration Utility, open the **Security > Event Logs:
   Logging Profiles** then click **Create.** Enter a Profile Name
   **asm_allrequests**, select the checkbox for **Application
   Security,** change the **Configuration** dropdown to **Advanced**,
   and then set the **Response Logging** dropdown to **For All
   Requests.** Change the **Request Type** under storage filter to **All
   Requests.** Click **Finished.** Be aware logging all responses will
   put additional load on the BIG-IP.

.. image:: media/image10.png
   :width: 3.92394in
   :height: 2.87662in

2. In the Configuration Utility, open the **Local Traffic > Virtual
   Servers.** Select **vs_hackazon_http** and click the **Security >
   Policies.** Change the **Log Profile** option to **Enabled** and then
   move the **asm_allrequests** from Available to Selected and click
   **Update**.

Note that the Application Security Policy has already been applied per
the wizard.

   .. image:: media/image11.png
      :width: 4.33371in
      :height: 3.60031in

3. Generate trusted learning suggestions by browsing the Auction site
   via the protected virtual server.

   a. Use the **Firefox** browser to access http://hackazon.f5demo.com

   b. Select **Sign In** in the upper right corner and attempt to login
      to the site using guessed credentials of **student/student** and
      submit them with the **Sign In** button. The login will fail, but
      will generate learning suggestions which is all we are looking for
      at this time..

..

   .. image:: media/image12.png
      :width: 3.34665in
      :height: 2.48958in

c. In the Configuration Utility, open the **Security > Application
   Security > Policy > Audit > Log** page and you’ll notice that as a
   result of interaction with the web site, elements are being added to
   the Policy by the Policy Builder as the ASM is learns the
   application. It may take a minute or so for all the elements to show.
   Since the requests came from a trusted device, you can click the
   “\ **Apply Policy**\ ” button if “\ **Changes have not been applied
   yet**\ ” is displayed.

..

   .. image:: media/image13.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10ae9682.PNG
      :width: 4.87098in
      :height: 3.65104in

d. Return to the Hackazon using a private browser window, select **Sign
   In** and re-attempt a login to the site using
   **verylong.username@example.com/pa$$wordwithspecia!s**

e. Return to the **Security > Application Security > Policy > Audit >
   Log** page in the F5 Configuration Utility and notice that further
   updates have been made to the Policy. Click the “\ **Apply
   Policy**\ ” button if “\ **Changes have not been applied yet**\ ” is
   displayed

..

   .. image:: media/image14.png
      :width: 4.41667in
      :height: 1.25454in

f. The login form has now been “learned” by the Policy Builder and added
   to the policy.

4. In the Configuration Utility, open the **Security > Application
   Security > Traffic Learning** page. You will see that this page has
   change a lot and has consolidated a lot of information, such as the
   learned entities. Review this page.

.. image:: media/image15.png
   :width: 4.26042in
   :height: 2.23795in

.. image:: media/image16.png
   :width: 3.83336in
   :height: 2.03127in

5. Under the **Entity Type** column in the **Parameter** row click on
   the **Total** number and you will see the parameters you discovered.
   Select a parameter and you will see how the parameter is configured.
   Note the maximum length that was set after you put in a long username
   and password.

6. Open **Security->Event Logs->Application->Requests.** Under
   **Requests Lists** remove the **Illegal Request** filter by clicking
   the **X.** You should see log entries with recent timestamps. Look
   for the **/user/login** entry with the violation rating. Note the
   violation and reason **Illegal parameter value length**. That is
   because the initial length was set to 10 as the BIG-IP was learning.
   Note the username and password at the bottom of the decoded request.
   BIG-IP does not reveal sensitive parameters in the log files.

..

   .. image:: media/image17.png
      :width: 6.4218in
      :height: 4.33368in

7. A policy change be modified at any time and there are numerous
   additional settings in the **Advanced** menu. In the Configuration
   Utility, open the **Security->Application Security->Policy Building >
   Learning and Blocking Settings**. Make sure the **Advanced** view
   option is selected.

.. image:: media/image18.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10cdb3f6.PNG
   :width: 6.5in
   :height: 2.46025in

Click **Auto-Apply Policy** (the name, not drop-down) to get a
description of the configuration item.

8. You are now finished building the policy for this exercise. You need
      to set the **Enforcement Mode** to **Blocking** and you need to
      remove the client network from the trusted IP addresses so that
      you can attempt to attack the Auction Website from your client PC.
      From the **Policy Building Process** section select the **Trusted
      IP Addresses** link and remove the 10.1.10.0/24 entry from the
      **IP Address Exceptions List.**

.. image:: media/image19.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10d0b0ab.PNG
   :width: 6.5in
   :height: 3.39719in

.. image:: media/image20.png
   :width: 5.85942in
   :height: 1.22918in

9. At the top of the page, click the **Apply Policy** button to apply
   your changes.

Exercise 2 – Policy Staging
===========================

Objectives:

-  Demonstrate SQL Injection

-  Demonstrate Forceful Browsing

-  Signature staging behavior

-  Estimated time for completion: **20 minutes**

Understanding Staging
---------------------

If you look at the OWASP ZAP session you opened earlier you will see the
ZAP detected a potential SQL Injection vulnerability.

.. image:: media/image21.png
   :width: 6.36424in
   :height: 1.44895in

What this indicates is the username parameter will process the
metacharacters that can be used to craft a successful attack. You are
going to plug that hole.

Perform a SQL Injection
~~~~~~~~~~~~~~~~~~~~~~~

1. Close your last Firefox browser to the Hackazon site and open **new**
   FireFox browser to http://hackazon.f5demo.com and select **Sign In**
   in the upper right corner of the page.

2. Enter ZAP' AND '1'='1' in the **Username** section and anything you
   want for the password.

..

   .. image:: media/image22.png
      :width: 2.40178in
      :height: 1.7947in

3. You will get a 503 Service Temporarily Unavailable response. This
   means your SQL injection got through and web server returned an error
   trying to process the request. This tells a hacker that if he can
   correctly craft the attack he will probably get through.

4. In the Configuration Utility, open the **Security->Event
   Logs->Application->Requests**. Remove the **Illegal Requests**
   filter. Click on the entry that contains **[HTTP] /user/login** with
   a **503**\ *response code (It will be the request in the list with a
   violation rating)*

..

   .. image:: media/image23.png
      :width: 6.5in
      :height: 0.82083in

   Click on the violations and you will notice t multiple signatures
   match this request and we can see these attack signatures are
   currently in staging.

   .. image:: media/image24.png
      :width: 6.5in
      :height: 3.56528in

5. Click on the **Violation** and you will the BIG-IP suspects an SQL
   Injection attack, click on the **Occurrences** you will see the
   signature is in **Staging**. If in **Blocking** mode, this means the
   attack is logged but not blocked until the staging period is
   complete. Explore the page further for additional information. If you
   are in **Transparent** mode, blocking will never occur, regardless of
   the staging settings.

..

   .. image:: media/image25.png
      :width: 5.19905in
      :height: 3.27776in

Perform a Cross Site Scripting attack
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Again, if you look at the OWASP ZAP Alerts under **Cross Site Scripting
(Reflected)** from the scanning section you will see there was a
successful Cross Site Scripting attack against the search page. You can
perform the attack by:

Entering the following into the search box:

<script>alert(1);</script>

Entering the following into the URL:
http://hackazon.f5demo.com/search?id=&searchString=%22%3Cscript%3Ealert%281%29%3B%3C%2Fscript%3E%22

**Note:** This attack uses URL encoding in the XSS attack script.

1. Open the Firefox browser and access http://hackazon.f5demo.com
   virtual server.

**NOTE: IF your browser is already open, close it and open a new browser
window.**

2. Past in the URL above or copy and paste the URL from the OWASP ZAP
   alert. You should get a pop-up indicating the attack was successful.

3. In the Configuration Utility, open the **Security->Event
   Logs->Application->Requests.** Check all request by deleting the
   illegal request filter. You will see several new violations. Click on
   the entry that contains **[HTTP] /search.**

..

   You will notice several signatures detected. Explore the signatures,
   but also take a look at the **Original Request** and the **Decoded
   Request**. You will notice the BIG-IP normalized the request to match
   against the signatures.

   .. image:: media/image26.png
      :width: 6.5in
      :height: 3.57431in

Signature Staging
~~~~~~~~~~~~~~~~~

1. In the Configuration Utility, open the **Security > Application
   Security > Policy Building > Learning and Blocking Settings.** Notice
   the **Enforcement Mode**. Because enforcement is set to **Blocking**
   once **Staging** is complete or removed, violations will be blocked.
   Under the **Policy Building Settings** section, expand the **Attack
   Signatures** section\ **.** Uncheck **Enable Signature Staging** and
   click **Save** and **Apply Policy.**

.. image:: media/image27.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML5254511.PNG
   :width: 4.65052in
   :height: 4.38021in

2. Open a new browser window to the auction site and repeat the SQL
   Injection attack **ZAP' AND '1'='1'** in the Username field of the
   login form). You will notice that the attack does not get blocked,
   however; the attack signature is still detected in the Event Log. The
   reason for this is that the **username** parameter is also in
   staging. Open **Security->Application
   Security->Parameters->Parameters List.** You will see that the
   username parameter is in staging and also has learning suggestions:

.. image:: media/image28.png
   :width: 4.28649in
   :height: 1.31251in

3. Click on **username** and uncheck the box for **Perform Staging** and
   click **Update**, then **Apply Policy**.

.. image:: media/image29.png
   :width: 3.80211in
   :height: 2.4896in

4. Repeat the SQL injection you and you should now see the blocking page

..

   .. image:: media/image30.png
      :width: 5.79245in
      :height: 1.20833in

5. Copy the **support ID**. You will use it in a moment.

6. If you go back to the Event Logs and look at Application requests.
   You will see the request now shows up with the **Illegal Requests**
   filter on.

.. image:: media/image31.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML4757d9e.PNG
   :width: 5.84375in
   :height: 2.03335in

7. Copy the support ID from the ASM Blocking Page. In the Configuration
   Utility, open the **Security->Event Logs->Application->Requests** and
   click the **Show Filter Details**. Scroll down to the **Support ID**
   section and paste the **Support ID** in the empty field then click
   **Apply Filter**. This should bring up the log entry for the most
   recent SQL injection that was just blocked. Review the entry and
   clear the filter.

..

   .. image:: media/image32.png
      :width: 4.03759in
      :height: 4.35937in

8. Let’s assume the **Username** parameter has been out of staging and
   enforced for a while. Go to the **Security ›› Application Security :
   Policy Building : Traffic Learning**. Under the **Enforcement
   Readiness Summary** in the **Entity** column, select the filter icon
   to the left of **Parameters**

..

   .. image:: media/image33.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML48b3fbf.PNG
      :width: 6.5in
      :height: 2.69651in

9. Here you will see the **Attack Signature detected** violations for
   the **Parameter: username**. Click on the **Accept Suggestion**
   button. At this point you can accept the suggestion outright or
   accept the suggestion AND place the parameter back into staging mode
   while you determine if the request was legitimate or not.

..

   .. image:: media/image34.png
      :width: 5.349in
      :height: 3.53128in

   Select Accept suggestion and enable staging on matched parameter and
   go back to the parameter list. You will see that **username** is back
   in staging mode and it you hovered over the icon you can see when
   staging began.

   .. image:: media/image35.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML494e74e.PNG
      :width: 6.5in
      :height: 1.12882in

This completes the ASM Policy Building Lab Section

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

   .. image:: media/image36.png
      :width: 3.71636in
      :height: 2.29145in

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

2. Select **Save** in the upper right corner.

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

   .. image:: media/image37.png
      :width: 2.53998in
      :height: 3.10638in

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

   .. image:: media/image38.png
      :width: 2.69149in
      :height: 2.14821in

5. Finally, select **Update**.

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

.. image:: media/image39.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML1996f7f9.PNG
   :width: 5.01064in
   :height: 2.74204in

   The BoT signature and category are logged and the BoT is allowed
   because the **Untrusted Bot** category is set to **Alarm** only.

   In the **Security ›› Event Logs : Bot Defense : Bot Traffic** screen
   it may take a few minutes for the data to show up, but you should see
   something similar to the following:

   .. image:: media/image40.png
      :width: 3.6383in
      :height: 1.97279in

This time we will use the apache bench (ab) BoT from the **DOS Tools
(Malicious)** category. The BoT was originally design for benchmark
testing but is mostly used for those nefarious purposes I spoke of
earlier.

2. From a terminal window on the jumpbox run the following:

ab -c 10 -n 10 -r http://hackazon.f5demo.com/

In the DoS event log you can see this BoT was **Denied** (blocked) by
sending a TCP reset immediately to the client.

.. image:: media/image41.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML199e6d75.PNG
   :width: 4.21844in
   :height: 2.30851in

If you go back to the **Bot Traffic** dashboards you will see the new
attacks. If you select **View Detected Bots** at the bottom you will get
a summary of the incidents.

.. image:: media/image42.png
   :width: 4.7766in
   :height: 2.3883in

You are now going to use the OWASP ZAP tool to run a spider bot attack
against the Hackazon website.

3. From the **Applications Menu** in the upper left-hand corner of the
   jumpbox go to **OWASP > Proxies > ZAP**.

4. Once ZAP is open, click on **Start** when asked **Do you want to
   persist the ZAP session**.

5. In the **Quick Start** tab, in the **URL Attack** box, enter
   http://hackazon.f5demo.com and hit the **Attack** button\ **.**

..

   .. image:: media/image43.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTMLaa9baf9.PNG
      :width: 2.84375in
      :height: 1.34702in

6. Once the attack has started a **Spider** tab should appear in the
   bottom ZAP window. You will see ZAP attempting to crawl the web site.
   **T**\ he attack will be short lived.

.. image:: media/image44.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML19aa6983.PNG
   :width: 4.25532in
   :height: 1.07879in

Without Bot protection it would have scan the site.

.. image:: media/image45.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTMLaafc85a.PNG
   :width: 4.26538in
   :height: 1.10417in

7. Check the Bot Requests you’ll find Non-browser presenting as Internet
   Explorer request. Go to **All Details** and check out the attack and
   how BIG-IP detected it.

Now let’s see how BIG-IP challenges Bots that don’t match up to the
signatures. We already saw some of this with OWASP Zap, but here you
will see the BIG-IP challenge the client to prove it’s not a Bot.

1. Go to Bot Request, find a curl request and look at the **Request**
   section. In it you will find the User-Agent set to curl/7.52.1

.. image:: media/image46.png
   :width: 1.53191in
   :height: 0.92059in

2. That makes it kind of easy to detect, but what if we changed the
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

.. image:: media/image47.png
   :width: 3.86461in
   :height: 2.28648in

.. image:: media/image48.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML19ba8c20.PNG
   :width: 4.4136in
   :height: 2.41489in

3. On you Bot Traffic dashboard you can see the Browser Masquerading
   category

.. image:: media/image49.png
   :width: 3.58511in
   :height: 2.56141in

Exercise 4 – Protecting Credentials with DataSafe
=================================================

Objectives:

-  The purpose of this lab is to show the new DataSafe perpetual license
   in 13.1.

-  You will review the login page with and without DataSafe protections.

-  You will enable and test encryption, obfuscation, and decoy fields.

Estimated completion time: 45 minutes

Exercise 1 – Review and Attack the Login Page
---------------------------------------------

Task 1 – Review Form Fields with the Developer Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Open Firefox and access
   `http://hackazon.f5demo.com/user/login. <http://hackazon.f5demo.com/user/login>`__

-  Right-click inside the **Username or Email** field and select
   **Inspect Element**.

..

   *Question:*

   What is the **name** value for this field?

-  Right-click inside the **Password** field and select **Inspect
   Element**.

..

   *Question:*

   What is the **name** value for this field?

Task 2 – Review Methods for Stealing Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  In Firefox click the **FPS Demo Tools** bookmark.

..

   This includes tools that behave like real malware.

-  On the login page enter your first name as username and **P@ssw0rd!**
      as password but do not click **Sign In**.

-  From the **Demo Tools** click **Steal Password**, and then click on
   the password field.

..

   The “malware” is using JavaScript to grab the value of the password
   field out of the DOM (Document Object Model). This is one way that
   malware can steal credentials; even before the user has submitted
   them to the application.

-  Click **OK**, then clear the password you entered.

-  From the **Demo Tools** click **Start Keylogger**, and then enter the
   same password from earlier.

-  |image1|\ Watch the top of the Demo Tools.

..

   This is another way that malware can steal credentials. The “malware”
   is using a JavaScript keylogger to log the password as it is typed.

-  In the developer tools select the **Network** tab, then click the
   trash can icon to delete the requests.

-  On the login page (with your first name and **P@ssw0rd!** entered)
   click **Sign In**.

-  In the **Network** tab select the **/login?return_url=** entry, and
   then examine the **Params** tab.

..

   .. image:: media/image51.png
      :width: 3.37083in
      :height: 1.11944in

   The user’s credentials are visible in clear text. This is another way
   that malware can steal credentials.

   By “grabbing” the POST request and any data sent with it, including
   username and password.

Task 3 – Perform a Form Field “Web Inject”
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Return to the http://hackazon.f5demo.com/user/login page.

-  Right-click inside the **Username or Email** field and select
   **Inspect Element** again.

-  |image2|\ Right-click on the highlighted text and select **Edit as
   HTML**.

-  Select all the text in the window and type **Ctrl+C** to copy the
   text.

-  Click after the end of **type="text">** and type **<br>**, and then
   press the **Enter** key twice.

-  |image3|\ Type **Ctrl+V** to paste the copied text.

-  For the new pasted entry, change the **name**, **id**, and
   **data-by-field** values to **mobile**, and change the

..

   |image4|\ **placeholder** value to **Mobile Phone Number**.

-  Click outside of the edit box and examine the Hackazon login page.

..

   This is an example of the type of “web injects” that malware can
   perform to collect additional information. This same technique could
   be used to remove text or form fields. Note that this was done on the
   client side, in the browser, without any requests being sent to the
   server. The web application and any security infrastructure
   protecting it would have no idea this is happening in the browser.

-  Close Firefox.

Exercise 2 – Review and Configure DataSafe Components
-----------------------------------------------------

Task 1 – DataSafe Licensing and Provisioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  |image5|\ In the Configuration Utility, navigate to **System** and
      right-click on **License**, and then select **Open Link in New
      Tab**, and then select the new tab.

..

   **DataSafe** includes only the Application Layer Encryption (ALE)
   module of WebSafe. Unlike WebSafe, **DataSafe** is licensed
   perpetually per device, just like ASM, APM, or any other licensed
   module.

   **DataSafe** is **NOT** included in the Best Bundle.

-  |image6|\ Open the **System > Resource Provisioning** page.

..

   When **DataSafe** is licensed, **Fraud Protection Service (FPS)**
   will display as **Licensed**. This is different than **WebSafe**,
   where Fraud Protection Services will show up as N/A.

   .. image:: media/image57.png
      :width: 5.02014in
      :height: 0.30694in

-  Expand the **Security** menu.

..

   There is a **Data Protection** option. This is different than WebSafe
   where this menu option is

Fraud Protection Service. DataSafe
                                  

   .. image:: media/image58.png
      :width: 1.86319in
      :height: 1.7875in

|image7|\ WebSafe
                 

Task 2 – DataSafe Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  Open the **Security > Data Protection > DataSafe Profiles** page and
   click **Create**.

-  For **Profile Name** enter **Hackazon-DS**.

-  |image8|\ On the left menu click **URL List**, and then click
   **Add**.

-  For **URL Path** leave **Explicit** selected, and type
      **/user/login**.

-  From the left panel open the **Parameters** page.

..

   Remember from earlier you found that the username and password
   parameter names are **username**

   and **password**.

-  Create a new parameter named **username**, and then click **Add**.

-  Create a second parameter named **password**, and then click **Add**.

-  Scroll to the right to view all the parameter options.

-  For the **username** parameter select the **Obfuscation** checkbox.

-  For the **password** parameter select the **Encrypt**, **Substitute
      Value**, and **Obfuscate** checkboxes.

.. image:: media/image62.png
   :width: 6.05969in
   :height: 0.40426in

-  Scroll to the left, and from the left menu open the **Application
   Layer Encryption** page. Notice that most features are enabled by
   default.

-  Review the explanations for the different features.

-  |image9|\ Select the **Add Decoy Inputs** and **Remove Element IDs**
   checkboxes, and then click **Create**.

-  Open the **Virtual Server List** page and click **vs_hackazon_http**,
      and then open the virtual server **Security > Policies** page.

-  From the **Anti-Fraud Profile** list select **Enabled**.

-  |image10|\ From the **Profile** list box, select **Hackazon-DS**, and
   then click **Update.**

Exercise 3 – Testing DataSafe Protection
----------------------------------------

Task 1 – Review the Protected Hackazon Login Page
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Open a **private** Firefox window and access
   http://hackazon.f5demo.com/user/login.

-  Right-click inside the **Password** field and select **Inspect
   Element**.

..

   *Question:*

   What is the **name** value for this field?

.. image:: media/image65.png
   :width: 6.15417in
   :height: 0.80417in

   **Obfuscation** - Notice that the name of the password field
   (outlined in red) is now a long cryptic name and is changing every
   second. The same is true of the username field.

   **Add Decoy Inputs** – Notice that there are other random inputs
   being added (outlined in green). The number and order of these inputs
   is changing frequently.

-  In Firefox click the **FPS Demo Tools** bookmark.

-  On the login page enter **P@ssw0rd!** as password but do not click
   **Sign In**.

-  |image11|\ From the **Demo Tools** click **Steal Password**, and then
   click on the password field.

..

   **Substitute Value –** DataSafe is protecting the password field from
   malware JavaScript grabbing the value of the field from the DOM.
   Uppercase letters are replaced with “A”, lower case letters are
   replaced with “a”, and non-alphanumeric characters are replaced with
   “!”.

-  Click **OK**, then clear the password you entered.

-  |image12|\ From the **Demo Tools** click **Start Keylogger**, and
      then begin entering the same password from earlier while watching
      the demo tools title bar.

..

   **Keylogger Protection** – DataSafe injected java script is injecting
   fake keystrokes to protect the page from software keyloggers common
   in some malware.

-  Close the FPS Demo Tool.

-  In the developer tools window select the **Network** tab, then click
      the trash can icon to delete any current requests.

-  On the login page (with your first name and **P@ssw0rd!** entered)
   click **Sign In**.

-  In the **Network** tab select the **/login?return_url=** entry, and
   then examine the **Params** tab.

..

   *Questions:*

   What parameters were submitted?

   Do you see a username or password field?

   Do you see the username you submitted?

   **Obfuscation** – DataSafe obfuscates the names of the parameters
   when they are submitted in a login request.

   **Encryption** – DataSafe encrypted the value of the password field
   so that it is not a readable value in the login request.

These two features together protect sensitive parameters.

.. |image1| image:: media/image50.png
   :width: 2.69583in
   :height: 0.45417in
.. |image2| image:: media/image52.jpeg
   :width: 3.87222in
   :height: 2.70208in
.. |image3| image:: media/image53.png
   :width: 6.02083in
   :height: 0.80417in
.. |image4| image:: media/image54.png
   :width: 5.3875in
   :height: 0.35417in
.. |image5| image:: media/image55.png
   :width: 2.32917in
   :height: 1.23403in
.. |image6| image:: media/image56.png
   :width: 4.47847in
   :height: 0.81875in
.. |image7| image:: media/image60.png
   :width: 1.8625in
   :height: 0.75972in
.. |image8| image:: media/image61.jpeg
   :width: 5.26528in
   :height: 0.90417in
.. |image9| image:: media/image63.png
   :width: 2.42917in
   :height: 1.3625in
.. |image10| image:: media/image64.jpeg
   :width: 3.6375in
   :height: 0.6375in
.. |image11| image:: media/image66.png
   :width: 2.02083in
   :height: 1.22083in
.. |image12| image:: media/image67.png
   :width: 2.6875in
   :height: 0.45417in
