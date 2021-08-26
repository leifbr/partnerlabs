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

.. image:: /_static/advwaf/image21.png
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

   .. image:: /_static/advwaf/image22.png
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

   .. image:: /_static/advwaf/image23.png
      :align: center
      :width: 500

   Click on the violations and you will notice t multiple signatures
   match this request and we can see these attack signatures are
   currently in staging.

   .. image:: /_static/advwaf/image24.png
      :align: center
      :width: 500

1. Click on the **Violation** and you will the BIG-IP suspects an SQL
   Injection attack, click on the **Occurrences** you will see the
   signature is in **Staging**. If in **Blocking** mode, this means the
   attack is logged but not blocked until the staging period is
   complete. Explore the page further for additional information. If you
   are in **Transparent** mode, blocking will never occur, regardless of
   the staging settings.

..

   .. image:: /_static/advwaf/image25.png
      :align: center
      :width: 500

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

   .. image:: /_static/advwaf/image26.png
      :align: center
      :width: 500

Signature Staging
~~~~~~~~~~~~~~~~~

1. In the Configuration Utility, open the **Security > Application
   Security > Policy Building > Learning and Blocking Settings.** Notice
   the **Enforcement Mode**. Because enforcement is set to **Blocking**
   once **Staging** is complete or removed, violations will be blocked.
   Under the **Policy Building Settings** section, expand the **Attack
   Signatures** section\ **.** Uncheck **Enable Signature Staging** and
   click **Save** and **Apply Policy.**

.. image:: /_static/advwaf/image27.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML5254511.PNG
   :align: center
   :width: 500

2. Open a new browser window to the auction site and repeat the SQL
   Injection attack **ZAP' AND '1'='1'** in the Username field of the
   login form). You will notice that the attack does not get blocked,
   however; the attack signature is still detected in the Event Log. The
   reason for this is that the **username** parameter is also in
   staging. Open **Security->Application
   Security->Parameters->Parameters List.** You will see that the
   username parameter is in staging and also has learning suggestions:

.. image:: /_static/advwaf/image28.png
   :align: center
   :width: 500

1. Click on **username** and uncheck the box for **Perform Staging** and
   click **Update**, then **Apply Policy**.

.. image:: /_static/advwaf/image29.png
   :align: center
   :width: 500

1. Repeat the SQL injection you and you should now see the blocking page

..

   .. image:: /_static/advwaf/image30.png
      :align: center
      :width: 500

1. Copy the **support ID**. You will use it in a moment.

2. If you go back to the Event Logs and look at Application requests.
   You will see the request now shows up with the **Illegal Requests**
   filter on.

.. image:: /_static/advwaf/image31.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML4757d9e.PNG
   :align: center
   :width: 500

7. Copy the support ID from the ASM Blocking Page. In the Configuration
   Utility, open the **Security->Event Logs->Application->Requests** and
   click the **Show Filter Details**. Scroll down to the **Support ID**
   section and paste the **Support ID** in the empty field then click
   **Apply Filter**. This should bring up the log entry for the most
   recent SQL injection that was just blocked. Review the entry and
   clear the filter.

..

   .. image:: /_static/advwaf/image32.png
      :align: center
      :width: 500

1. Let’s assume the **Username** parameter has been out of staging and
   enforced for a while. Go to the **Security ›› Application Security :
   Policy Building : Traffic Learning**. Under the **Enforcement
   Readiness Summary** in the **Entity** column, select the filter icon
   to the left of **Parameters**

..

   .. image:: /_static/advwaf/image33.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML48b3fbf.PNG
      :align: center
      :width: 500

9. Here you will see the **Attack Signature detected** violations for
   the **Parameter: username**. Click on the **Accept Suggestion**
   button. At this point you can accept the suggestion outright or
   accept the suggestion AND place the parameter back into staging mode
   while you determine if the request was legitimate or not.

..

   .. image:: /_static/advwaf/image34.png
      :align: center
      :width: 500

   Select Accept suggestion and enable staging on matched parameter and
   go back to the parameter list. You will see that **username** is back
   in staging mode and it you hovered over the icon you can see when
   staging began.

   .. image:: /_static/advwaf/image35.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML494e74e.PNG
      :align: center
      :width: 500

This completes the ASM Policy Building Lab Section