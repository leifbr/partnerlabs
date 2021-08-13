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

Before you begin, the penetration testing tool, OWASP ZAP, has already
been run against the website and the results have been saved. Let’s take
a look at the test to see the results. You will use this information to
plug a few holes.

1. Using OWASP ZAP
   1. **UDF** 
      1. From the Applications Menu in the upper left-hand corner of the jumpbox go to **OWASP > Proxies > ZAP**.

      2. Once ZAP is open, click on **Start** when asked Do you want to persist the ZAP session.

      3. Under **File** select **Open Session** and select **hackazon-zap-session.session**.
   2.  **AWS**
       1. If you don't already have it, download and install OWASP ZAP from https://www.zaproxy.org. 

2. Once the session is loaded, go to the **Alerts** tab, you will see a
   number of vulnerabilities found.

..

   .. image:: /_static/advwaf/image5.png
      :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTMLe2109f4e.PNG
      :align: centerz
      :width: 500

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

.. image:: /_static/advwaf/image6.png
    :align: center
    :width: 500

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

.. image:: /_static/advwaf/image7.png
   :align: center
   :width: 500

6. Review your security policy and click **Create Policy** at the upper
   left. It may take a few minutes. Notice you have a number of new
   things you can do with your security policy.

.. image:: /_static/advwaf/image9.png
   :align: center
   :width: 500

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

.. image:: /_static/advwaf/image10.png
   :align: center
   :width: 500

2. In the Configuration Utility, open the **Local Traffic > Virtual
   Servers.** Select **vs_hackazon_http** and click the **Security >
   Policies.** Change the **Log Profile** option to **Enabled** and then
   move the **asm_allrequests** from Available to Selected and click
   **Update**.

Note that the Application Security Policy has already been applied per
the wizard.

   .. image:: /_static/advwaf/image11.png
      :align: center
      :width: 500

3. Generate trusted learning suggestions by browsing the Auction site
   via the protected virtual server.

   a. Use the **Firefox** browser to access http://hackazon.f5demo.com

   b. Select **Sign In** in the upper right corner and attempt to login
      to the site using guessed credentials of **student/student** and
      submit them with the **Sign In** button. The login will fail, but
      will generate learning suggestions which is all we are looking for
      at this time..

..

   .. image:: /_static/advwaf/image12.png
      :align: center
      :width: 500

c. In the Configuration Utility, open the **Security > Application
   Security > Policy > Audit > Log** page and you’ll notice that as a
   result of interaction with the web site, elements are being added to
   the Policy by the Policy Builder as the ASM is learns the
   application. It may take a minute or so for all the elements to show.
   Since the requests came from a trusted device, you can click the
   “\ **Apply Policy**\ ” button if “\ **Changes have not been applied
   yet**\ ” is displayed.

..

   .. image:: /_static/advwaf/image13.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10ae9682.PNG
      :align: center
      :width: 500

d. Return to the Hackazon using a private browser window, select **Sign
   In** and re-attempt a login to the site using
   **verylong.username@example.com/pa$$wordwithspecia!s**

e. Return to the **Security > Application Security > Policy > Audit >
   Log** page in the F5 Configuration Utility and notice that further
   updates have been made to the Policy. Click the “\ **Apply
   Policy**\ ” button if “\ **Changes have not been applied yet**\ ” is
   displayed

..

   .. image:: /_static/advwaf/image14.png
      :align: center
      :width: 500

f. The login form has now been “learned” by the Policy Builder and added
   to the policy.

4. In the Configuration Utility, open the **Security > Application
   Security > Traffic Learning** page. You will see that this page has
   change a lot and has consolidated a lot of information, such as the
   learned entities. Review this page.

.. image:: /_static/advwaf/image15.png
   :align: center
   :width: 500

.. image:: /_static/advwaf/image16.png
   :align: center
   :width: 500


1. Under the **Entity Type** column in the **Parameter** row click on
   the **Total** number and you will see the parameters you discovered.
   Select a parameter and you will see how the parameter is configured.
   Note the maximum length that was set after you put in a long username
   and password.

2. Open **Security->Event Logs->Application->Requests.** Under
   **Requests Lists** remove the **Illegal Request** filter by clicking
   the **X.** You should see log entries with recent timestamps. Look
   for the **/user/login** entry with the violation rating. Note the
   violation and reason **Illegal parameter value length**. That is
   because the initial length was set to 10 as the BIG-IP was learning.
   Note the username and password at the bottom of the decoded request.
   BIG-IP does not reveal sensitive parameters in the log files.

..

   .. image:: /_static/advwaf/image17.png
      :align: center
      :width: 500

1. A policy change be modified at any time and there are numerous
   additional settings in the **Advanced** menu. In the Configuration
   Utility, open the **Security->Application Security->Policy Building >
   Learning and Blocking Settings**. Make sure the **Advanced** view
   option is selected.

.. image:: /_static/advwaf/image18.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10cdb3f6.PNG
   :align: center
   :width: 500

Click **Auto-Apply Policy** (the name, not drop-down) to get a
description of the configuration item.

8. You are now finished building the policy for this exercise. You need
      to set the **Enforcement Mode** to **Blocking** and you need to
      remove the client network from the trusted IP addresses so that
      you can attempt to attack the Auction Website from your client PC.
      From the **Policy Building Process** section select the **Trusted
      IP Addresses** link and remove the 10.1.10.0/24 entry from the
      **IP Address Exceptions List.**

.. image:: /_static/advwaf/image19.png
   :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML10d0b0ab.PNG
   :align: center
   :width: 500

.. image:: /_static/advwaf/image20.png
   :align: center
   :width: 500

1. At the top of the page, click the **Apply Policy** button to apply
   your changes.
