Create Credentials Protection WAF Child Policy
==============================================

Currently our policy is simply the original parent policy **waf_base**. This policy can be applied to all our application requiring basic application security.  Now we will customize the policy used by the Hackazon application to protect the login page and create a true child policy.  The child policy will still inherit any changes to the parent policy, but will have security settings unique to the application.

**Task 1 - Simulate credential attacks.**

#. Open browser and go to :guilabel:`http://10.1.10.100/user/login`
#. For **Username** enter :guilabel:`f5student`
#. For **Password** enter random incorrect password. Repeat 5 consecutive times using different password to simulate brute force attack

   .. NOTE::

      This is a common :guilabel:`brute force` attack. In this case the application allowed
      repeated attempts without lockout.  Some applications will send "account locked"
      for a period of time, ho
      wever user can continue to use repeated attempts to
      elongate lockout period.

In the next couple of tasks you will help mitigate brute force attacks against the Hackazon application and protect the users credentials as they enter them into the browser.

**Task 2 - Create new waf policy to mitigate the vulnerabilities using info on table below:**

.. list-table::
    :widths: 20 40
    :header-rows: 0
    :stub-columns: 0

    * - **Policy Name**
      - waf_baseCredentials
    * - **Policy Type**
      - Security
    * - **Parent Policy**
      - waf_base
    * - **Virtual Server**
      - none
    * - **Enforcement Mode**
      - Blocking

#. Select the **Security -> Application Security -> Security Policies -> Policies List** page
#. Click **Create New Policy** and enter info as shown in image below.

   .. image:: ./images/image341.png
     :height: 300px

#. Click **Save**

   .. image:: ./images/image339.png
     :height: 200px

.. NOTE::
   This time you did not encounter the bug because **Staging** was enabled in the parent policy.

**Task 3 - Configure Brute Force Protection**

Here you will set up brute force protection on the login page you were simulating an attack against earlier.  If you hit the **Sign In** button on the main page, you would have seen another way to log in.  In a production environment different login pages for the same application would have to be configured to be protected.

#. Select **Security -> Application Security -> Sessions and Logins -> Login Pages List** page
#. Click **Create**

   .. image:: ./images/image342.png
     :height: 500px

#. Fill in the details as in the image above, ensuring you are using the waf_baseCredentials policy and click on **Create**
#. Select **Security -> Application Security -> Brute Force Attack Prevention** then click **Create**
#. Change **Login Page** drop down box to :guilabel:`[HTTPS]/user/login` then click **Create**
#. Click **Apply Policy** then **OK** to commit changes

   .. image:: ./images/image343.png
     :height: 200px

**Task 4 - Assign policies to protect Hackazon App**

#. Select **Local Traffic -> Virtual Servers -> Virtual Servers List** and click on :guilabel:`hackazon_vs`
#. Select **Security** then **Policy** tab
#. Change the **Application Security Policy** to your new **waf_baseCredentials** policy.
#. Click **Update**

**Task 5 - Repeat simulated credential attacks**
Now you are ready to repeat the brute force attack simulation. 

#. Open browser and go to :guilabel:`http://10.1.10.100/user/login`
#. For **Username** enter :guilabel:`f5student`
#. For **Password** enter random incorrect password.  Repeat multiple times using different password to simulate brute force attack.  You should receive a Captcha challenge after 3-5 failed attempts.
#. Enter **captcha challenge** then enter correct credentials to login in successfully (good luck).
#. On the BIG-IP go to **Security -> Event Logs -> Application -> Brute Force Attacks** to view the what the BIG-IP logged.