Exercise 1 – ASM Policy Creation and Logging
============================================

.. important::
   **DO NOT CONFIGURE FROM THE FROM THE SCREENSHOTS AS THEY ARE NOT ALWAYS UPDATED AND MAY CONTAIN INACCURATE INFORMATION**

Create ASM Policy
-----------------

Objectives:

-  View the v15.x policy building GUI interface

-  Create a security policy using automatic policy building

-  Enable application security logging profile

-  Estimated time for completion: **20 minutes**

This lab will demonstrate how to create and build a security policy
using automatic policy building.

Before you begin, you should have the penetration testing tool, OWASP ZAP.  
- **AWS** - if you are using the AWS lab environment
- **UDF** - in the F5 UDF environment OWASP ZAP has already been install on the Jumpbox and 
been run against the website and the results have been saved. Let’s take
a look at the test to see the results. You will use this information to
plug a few holes.

* Using OWASP ZAP
   * In **UDF**:
      * From the Applications Menu in the upper left-hand corner of the jumpbox go to **OWASP > Proxies > ZAP**.
      * Once ZAP is open, click on **Start** when asked *Do you want to persist the ZAP session*.
      * Under **File** select **Open Session** and select **hackazon-zap-session.session**.
      * Once the session is loaded , go to the **Alerts** tab, you will see a number of vulnerabilities found. (see the image below).
   * In **AWS**:
       * If you don't already have it, download and install OWASP ZAP from https://www.zaproxy.org.
       * You can feel free to run OWASP ZAP against the Hackazon website at http://<Bigip1VipEipTo100>, but be it may take 20-30 minutes to complete.  The image below will give you an idea of what you would see.

   * **OWASP ZAP Partial Results** - As you can see, there are numerous vulnerabilities.

   .. image:: /_static/advwaf/image5.png
      :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTMLe2109f4e.PNG
      :align: center
      :width: 500

* We will be focusing on the CrossSite Scripting (XSS) and SQL Injection vulnerabilities discovered specifically, on the *Search* page and *User Login* page.
   * If you expand the tabs you can see the vulnerabilities found. Click on the page to get more detail.

Creating Application Security Policy
------------------------------------

* **Guided Configurations** is only available for Advanced WAF, so in deference to those still running Application Security Manager (ASM) we will build our policies using the **Create New Policy** wizard.

* On the Main tab, click **Security** > **Application Security** > **Security Policies**. The Active Policies screen opens.

* Click the **Create...** button. As you can see, security policy setup is done on a single page.

.. image:: /_static/advwaf/image6.png
    :align: center
    :width: 500

* Enter the following information in the **General Settings** section:

  * Name: **hackazon_asm**
  * Policy Type: **Security**
  * Policy Template: **Comprehensive**
  * Virtual Server: **vs_hackazon_http (HTTP)**
  * Logging Profiles: *you will build and add a logging profile later*
  * Application Language: **Unicode (utf-8)**
  * Under **Learning and Blocking**
    * Enforcement Mode: **Transparent**
    * Trusted IP: 
      * **UDF**: **10.1.10.0/255.255.255.0**
      * **AWS**: <your source IP address>
      * Policy Builder Learning Speed: **Fast**
  * Under **Advanced Settings**:
    * Server Technologies: <Select **Apache Tomcat**, **MySQL**, **Unix/Linux**>

**Server Technologies** assigns attack signatures base on the selected technologies, but can also learn new technologies based on HTTP Requests/Responses. The Hackazon website user PHP, which you did not enter. Later you will see if BIG-IP discovers PHP and adds the attack signatures.

You also made your PC/jumpbox a “trusted” client and set the learning speed to fast, so the policy will build quickly.

When you are done your configuration items should look something like this:

.. image:: /_static/advwaf/image7.png
   :align: center
   :width: 500

* Review your security policy and click **Save** at the upper left. It may take a few minutes. 

Once the policy is saved you will be back to your **Policies List**.  Select you new **hackazon_asm** policy.  Notice you have a number of new things you can do with your security policy.

.. image:: /_static/advwaf/image9.png
   :align: center
   :width: 500

Enable Application Security Logging
-----------------------------------

* In the Configuration Utility, open the **Security > Event Logs: Logging Profiles** then click **Create**
  * Enter the Profile Name **asm_allrequests**, select the checkbox for **Application Security,** 
  * Change the **Configuration** dropdown to **Advanced**
    * Set the **Response Logging** dropdown to **For All  Requests.**
    * Change the **Request Type** under **Storage Filter** to **All Requests.** 
  * Click **Finished.** 
  
Obviously logging all responses will put additional load on the BIG-IP and is not something you would normally do in production.

.. image:: /_static/advwaf/image10.png
   :align: center
   :width: 500

* In the Configuration Utility, open the **Local Traffic > Virtual Servers.** and select **vs_hackazon_http**
  * Click on **Security > Policies.** on the top bar. 
  * Change the **Log Profile** option to **Enabled** and then move the **asm_allrequests** profile from **Available** to **Selected**
  * Click **Update**.

Note that the Application Security Policy has already been applied per
the wizard.

   .. image:: /_static/advwaf/image11.png
      :align: center
      :width: 500

* Generate trusted learning suggestions by browsing the Auction site via the protected virtual server. 
    * **UDF** go to http://hackazon.f5demo.com
    * **AWS** go to http://<Bigip1VipEipTo100>

* Select **Sign In** in the upper right corner and attempt to login to the site using guessed credentials of **student/student** and submit them with the **Sign In** button. The login will fail, but will generate learning suggestions which is all we are looking for at this time.

   .. image:: /_static/advwaf/image12.png
      :align: center
      :width: 500

* In the Configuration Utility, open the **Security > Application Security > Audit > Log** page. You’ll notice that as a result of interaction with the web site, elements are being added to the Policy by the Policy Builder as AdvWAF learns the application. It may take a minute or so for all the elements to show. 
 
* Since the requests came from a trusted device, and you have selected **Automatic** as your **Policy Building Learning Mode** you can see the policy changes have been automatically applied in the audit log with the **Element Type** of **Apply Policy**.

   .. image:: /_static/advwaf/image13.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10ae9682.PNG
      :align: center
      :width: 500

* Return to the Hackazon using a private browser window, select **Sign In** and re-attempt a login to the site using **verylong.username@example.com/pa$$wordwithspecia!s**. Do this a several times.

*  Return to the **Security > Application Security > Audit > Log** page in the F5 Configuration Utility and notice that further updates have been made to the Policy. Again the updates to the policy have been made automatically.

   .. image:: /_static/advwaf/image14.png
      :align: center
      :width: 500

* The login form has now been “learned” by the Policy Builder and added to the policy.

* In the Configuration Utility, open the **Security > Application Security > Policy Building > Traffic Learning** page. You will see consolidated information around suggestions, learning progress and more.

.. image:: /_static/advwaf/image15.png
   :align: center
   :width: 500

   * Under the **Entity Type** column in the **Parameter** row click on the **Total** number and you will see the parameters you discovered.  Select a parameter and you will see how the parameter is configured. You can see the maximum length that was set after you put in a long username and password.
  
.. image:: /_static/advwaf/image16.png
   :align: center
   :width: 500



* Open **Security > Event Logs > Application > Requests.** You should see log entries with recent timestamps  Look for the **/user/login** entry with the violation rating. Note the violation and reason **Illegal parameter value length**. That is because the initial length was set to 10 as the BIG-IP was learning. Note the username and password at the bottom of the decoded request. BIG-IP does not reveal sensitive parameters in the log files.


.. image:: /_static/advwaf/image17.png
   :align: center
   :width: 500

* A policy change be modified at any time and there are numerous additional settings. For basic settings go to your policy under **Security > Application Security > Security Policies**, select your policy and in **General Settings** the **Learning and Blocking** section is available.  
  * For the next exercise you will require the **Enforcement Mode** to be **Blocking**.  Select **Blocking** mode now and select **Save** in the upper right.  *You could also* **Apply Policy** *at this point, but another policy change awaits.* 

.. image:: /_static/advwaf/image18.png
   :alt: General Settings for Learning and Blocking
   :align: center
   :width: 500

  * For advanced/customized Learning and Blocking settings open  **Security > Application Security > Policy Building > Learning and Blocking Settings**.

  .. image:: /_static/advwaf/image18a.png
  :alt: Advanced settings for Learning and Blocker
  :align: center
  :width: 500

* In addition to setting the **Enforcement Mode** to **Blocking** you need to remove the **Trusted IP Addresses** so that you can attempt to attack the Hackazon website from your client PC. Expand the **Policy Building Process** section select the **Trusted IP Addresses** link.  This will take you to **Security > Application Security > IP Addresses > IP Address Exceptions** and remove the entries from the **IP Address Exceptions List.**

.. image:: /_static/advwaf/image19.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10d0b0ab.PNG
   :align: center
   :width: 500

.. image:: /_static/advwaf/image20.png
   :align: center
   :width: 500

* At the top of the page, click the **Apply Policy** button to apply your changes.
