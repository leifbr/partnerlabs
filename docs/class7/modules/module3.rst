Exercise 2 – Policy Staging
===========================

Objectives:

-  Demonstrate SQL Injection

-  Demonstrate Forceful Browsing

-  Signature staging behavior

-  Estimated time for completion: **20 minutes**

Understanding Staging
---------------------
Staging is an important concept in Advanced WAF (AWAF).  Staging allows AWAF to create policies, but also gives adminstrators time to review a policy prior to the policy being implemented. The default staging period for both positive and negative security policies is 7 days, but the staging period is adjustable by the administrator and can be overridden in desired.

In this lab you are going to perform a simulate SQL injection attack.  AWAF will detect the attack, make a suggestion and a policy rule, but will not implment the policy rule immediately because of staging.

One of vulnerabilities OWASP ZAP detected was a potential SQL Injection vulnerability.

.. image:: /_static/advwaf/image21.png
   :alt: OWASP ZAP SQL Injection alert on /user/login
   :align: center
   :width: 500

What this indicates is the username parameter will process the metacharacters that can be used to craft a successful attack. A hacker would take this information and begin to craft injection attacks that will eventually be successfull.  AWAF and you are going to plug that hole.

Perform a SQL Injection
~~~~~~~~~~~~~~~~~~~~~~~

* Close your last browser to the Hackazon site and open **new**  browser to Hackazon virtual server and select **Sign In** in the upper right corner of the page.

* Enter ``ZAP' AND '1'='1'`` (note the single quotes if you decide to type it in) in the **Username** section and anything you want for the password.

   .. image:: /_static/advwaf/image22.png
      :alt: Login box
      :align: center
      :width: 300

* You will get a 503 Service Temporarily Unavailable response. This means your SQL injection got through and web server returned an error trying to process the request. This tells a hacker that if he can correctly craft the attack he will probably get through.
|
* In the Configuration Utility, open the **Security > Event Logs > Application > Requests**. Click on the entry that contains **[HTTP] /user/login** with a **503** *response code (It will be the request in the list with a high violation rating)*

Click on the violation and you will notice multiple signatures match this request and we can see these attack signatures are currently in staging.

   .. image:: /_static/advwaf/image24.png
      :alt: Application Request - All Requests shown
      :align: center
      :width: 500

* Click on the **Violation** and you will the BIG-IP suspects an SQL Injection attack, click on the **Occurrences** you will see the signature is in **Staging**. If AWAF is in **Blocking** mode, the attack would be logged but not blocked until the staging period is complete. Explore the page further for additional information. If you are in **Transparent** mode, blocking will never occur, regardless of the staging settings.

   .. image:: /_static/advwaf/image25.png
      :alt: Detailed attack signature information about SQL injection attack
      :align: center
      :width: 500

Perform a Cross Site Scripting attack
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Again, if you look at the OWASP ZAP Alerts under **Cross Site Scripting (Reflected)** from the scanning section you will see there was a successful Cross Site Scripting attack against the search page.

* Close your current Hackazon browser window and open a new private window to the Hackazon application and peform the following **Cross Site Scripting** attacks against the application.  In each instance you will receive a pop-up alert which indicates the attack is successful.

   * Entering the following into the search box:

   ``<script>alert(1);</script>``

  * Attack the application using URL encoding.  Append the following after the URL host:

   ``/search?id=&searchString=%22%3Cscript%3Ealert%281%29%3B%3C%2Fscript%3E%22``

Your URL should look like this *http://<host name or ip>/search?id=&searchString=%22%3Cscript%3Ealert%281%29%3B%3C%2Fscript%3E%22*

.. note::
   This attack uses URL encoding to obfuscate the XSS attack as way of bypassing signature checks. AWAF always *normalizes* requests as they come to prevent obfuscated attacks from bypassing the policy.

* In the Configuration Utility, open the **Security > Event Logs > Application > Requests.**  You will see several new high level violations. Click on the entry that contains **[HTTP] /search** when you sent the encode URL XSS attack.

Here you can see a more detailed description of the attack

   .. image:: /_static/advwaf/image26.png
      :alt: Detail request information for the XSS attack.
      :align: center
      :width: 500

By expanding the **Original Request** you can view the **Decoded Request** and the **Original Request** to see how AWAF normalized (decoded) the request and then ran the request against the policy.

.. image:: /_static/advwaf/image26a.png
   :alt: Decoded request versus Original Request
   :align: center
   :width: 500

Signature Staging
~~~~~~~~~~~~~~~~~
You have the AWAF in **Blocking** mode, but attacks are only being logged and not blocked at this point because the **Signatures** are still in staging.  Go to **Security > Application Security > Policy Building > Traffic Learning** you will see a lot of new information is provided based the requests receives.  Let's assume you have review the information in the **Reduce Potential False-positive Alerts** section and the **Enforcement Readiness Summary** and are ready for AWAF to start truly protecting the application.

.. note::
   If you are using the AWS lab environment you may see additional attacks beyond the ones you sent since you are using a public IP address access the application.  It does not take long for BoTs to find your new application and start looking for exploits.  The same holds true for **ANY** internet facing application.

* In the Configuration Utility, open the **Security > Application Security > Policy Building > Learning and Blocking Settings**. 
  * Expand the **Policy Building Settings** Notice most signatures are set to **Alarm** (ie. log) and **Block**. Because enforcement mode is set to **Blocking** in the policy once **Staging** is complete or removed, violations will be blocked.  
  * In the **Policy Building Settings** section, under **Attack Signatures** find an uncheck **Enable Signature Staging** and click **Save** (all the way down at the bottom of the page).

.. image:: /_static/advwaf/image27.png
   :alt: Disabling Signature Staging 
   :align: center
   :width: 500

   * At this point the should be a **Changes not applied** warning next to the **Apply Policy** button in the upper right. Click the button to apply the policy.

   .. image:: /_static/advwaf/image27a.png
   :alt: Disabling Signature Staging 
   :align: center
   :width: 500

   .. important::
      When you change an AWAF policy manually you must apply the changes before they will take effect. The **Changes not applied** warning will appear on the **Apply Policy** buttons for the policy that was changes. Failing to apply the policy will leave you wondering why your changes didn't take and have you troubleshooting to no avail (believe me I know).  

* Open a new private browser window to the to the Hackazon site and repeat the SQL Injection attack ``ZAP' AND '1'='1'`` in the Username field of the login form). 
  |
You will notice that the attack does not get blocked, however; the attack signature is still detected in the Event Log. The reason for this is that the **username** parameter is also in staging. Open **Security > Application Security > Parameters > Parameters List.** You will see that the username parameter is in staging and also has learning suggestions:

.. image:: /_static/advwaf/image28.png
   :alt: Reviewing parameters and staging 
   :align: center
   :width: 500

* Click on **username** and uncheck the box for **Perform Staging** and click **Update**. Don't forget to **Apply Policy**.

.. image:: /_static/advwaf/image29.png
   :alt: Username parameter details and disabling staging
   :align: center
   :width: 400

* Repeat the SQL injection you and you should now see the blocking page

   .. image:: /_static/advwaf/image30.png
      :alt: Advanced WAF default URL rejected page
      :align: center
      :width: 500

* Copy the **support ID**. You will use it in a moment.

* If you go back to the Event Logs and look at Application requests. You will see the request now shows up with the **Blocked** filter on.

.. image:: /_static/advwaf/image31.png
   :alt: Block Requests filter
   :align: center
   :width: 500

.. note::
   This screenshot was taken using the AWS-F5 lab environment.  As you can see even though the site hasn't been up long it is taking numerous attacks which AWAF is now blocking.

* You can also search for a particular request using the support ID from the AWAF Blocking Page. In the Configuration Utility, open the **Security > Event Logs > Application > Requests** and click the filter icon (next to **Order by Date**. Paste the **Support ID** in the empty field then click **Apply Filter**. This should bring up the log entry SQL injection request that was just blocked. Review the entry and clear the filter.

* The **Username** parameter has been out of staging and enforced. The application team has decided (without notify security) to allow users to use a username or their email address to log in which means some usernames will exceed the current length.
* Using a new private browser log into the Hackazon application
  * Username: firstname.lastname@mail.example.com
  * Password: password
* The request will be blocked cand you will be ask why. Get the support ID of the offending request. 

* Go to the Application event logs and find the offending request using the support ID. Open the request and you will set a **Illegal parameter value length** click **View...** under **Suggestions**.

.. image:: /_static/advwaf/image32.png
   :alt: Illegal parameter value in the request.
   :align: center
   :width: 500

A new window/tab will appear opening the the **Security › Application Security > Policy Building > Traffic Learning** page. Under **Suggestions**  you will see the illegal length for the parameter username highlighted.  The right under the buttons you will see the Suggestioned Action if you want to change the policy. You can take a number of actions.  You can:
   * **Accept Suggestion** the suggestion will will change the policy
   * **Accept Suggestion and Enable Staging on the Matched Parameter** which modifies the policy and puts the parameter back into staging (giving a chance to watch for a while)
   * **Delete** the suggestion, meaning the keeping policy will stay in place, but AWAF will relearn the suggestion if **Learning** is on for the parameter
   * **Ignore** the suggestion which keeps the policy as.

   .. image:: /_static/advwaf/image33.png
      :alt: Viewing the parameters in the **Enforcement Readiness Summary**
      :align: center
      :width: 500

* Since AppDev has changed how the application works you are going to click on the **Accept** button dropdown and select **Accept Suggestion and Enable Staging on the Matched Parameter**.  This way you can observe violations without necessary blocking legitimate request during the staging period.  At anytime you can accept new suggestions and them to the policy or, if the policy is automated the AWAF will apply the suggestion at the end of the staging period.

If you go back to the **username** parameter under **Security > Application Security > Parameters** and click on the username parameter you will see stage has been re-enable and the parameter length has changed to the suggested length.

Of course you can always set the policy manually if desired.

This completes the ASM Policy Building Lab Section