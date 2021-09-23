Exercise 4 – Protecting Credentials with DataSafe
=================================================

Objectives:

-  The purpose of this lab is to show how you can use DataSafe to protect and encrypt you customers credentials and other sensitive information on their browser. Preventing malware for logging or stealing the information out of the POST before its encrypted and returned to the server.

-  You will review the login page with and without DataSafe protections to review how exposed information is at the browser level.

-  You will then configure Datasafe and test Datasafes ability to obfuscate and encrypt html information as the page is sent and information is typed into the browser.

.. note::
   In this lab the **hackzon_vs** refers accessing the Hackazon application:
   For AWS access: **Bigip1VipEipTo100** in the AWS CFT output
   For UDF access: **hackazon.f5demo.com** or **10.10.1.100**

Estimated completion time: 45 minutes

Exercise 1 – Review and Attack the Login Page
---------------------------------------------

Task 1 – Review Form Fields with the Developer Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Open your browser and access the Hackazon login 
   ``http://<hackazon_vs>/user/login``

-  Right-click inside the **Username or Email** field and select **Inspect** or 
   **Inspect Element** (depending on the browser).

   * *Question: What is the* **name** *value for this field?*

-  Right-click inside the **Password** field and select **Inspect
   Element**.

   * *Question:* What is the* **name** *value for this field?*

These are not uncommon names for these variables.  You can see how easy it would be for malware to find and extract them.

Task 2 - Why Credentials Entered into the Brower are Vunerable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- In your browser window <right-click> and select **Inspect**, **Inspect Element** or enter ``<ctrl>+Shift+"i"`` to open the developer tools.

-  On the login page enter your first name as username and **P@ssw0rd!** as password and click **Sign In**.

-  In the developer tools select the **Network** tab, and clear the any requests/responses already there.

-  On the login page (with your first name and **P@ssw0rd!** entered)
   click **Sign In**.

-  In the **Network** tab select the **login** or **/login?return_url=** entry on the left of the **Inspect** pane under **Name**, select **Headers** to the right and scroll down to **Form Data** then examine the **Params** tab.

.. image:: /_static/advwaf/image51.png
   :alt: Developer Tools showing username and password
   :align: center
   :width: 500


The user’s credentials are visible in clear text. This means that prior to sending the login reponse to the Hackazon application server malware on the user's device could have logged the keystrokes or simply pulled the username and password out of the page or simply by “grabbing” the entire POST request clear text, reardless of HTTPS encryption.

.. important::
   The username and password **are not secured** until the page is send and hit the TLS session layer where the response is encrypted prior to being sent.


Task 3 – Perform a Form Field “Web Inject”
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Return to the ``http://<hackazon_vs>/user/login`` page.

-  Right-click inside the **Username or Email** field and select **Inspect Element** again.

-  Right-click on the highlighted text and select **Edit as HTML**.

.. image:: /_static/advwaf/image52.png
   :alt: Developer Tools Edit as HTML
   :align: center
   :width: 500

-  Select all the text in the window and type **Ctrl+C** to copy the text.

-  Click after the end of of the orignal string and type **<br>**, and then press the **Enter** key twice.  Type **Ctrl+V** to paste the copied text.

-  For the new pasted entry, change the **name**, **id**, and **data-by-field** values to **mobile**, and change the**placeholder** value to **Mobile Phone Number**.

.. image:: /_static/advwaf/image53.png
   :alt: Editing the HTML
   :align: center
   :width: 500

-  Click outside of the edit box and examine the Hackazon login page.

This is an example of the type of “web injects” that malware can perform to collect additional information. This same technique could be used to remove text or form fields. Note that this was done on the client side, in the browser, without any requests being sent to the server. The web application and any security infrastructure protecting it would have no idea this is happening in the browser.

-  Close your browser.

Exercise 2 – Review and Configure DataSafe Components
-----------------------------------------------------

Task 1 – DataSafe Licensing and Provisioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**DataSafe** is the Application Layer Encryption (ALE) module of AWAF. 

**DataSafe** is only available with Advanced WAF (AWAF). 
 
.. important::
   As of 1 APR 2020, **Application Security Manager** (ASM) and can be upgraded to  products can be upgrade to **Advanced WAF** (AWAF) for free.  Two requirements must be met.  The TMOS version must be v14.1 or higher and you are required to reactivated the license.

Datasafe must be licensed and provisioned to operate.  Open the provisioning page by going to **System > Resource Provisioning**.  Datasafe is provisioned under **Fraud Protection Service (FPS)** and should be **Licensed**.  If **Fraud Protection Service (FPS)** is not provisioned, provision it now.

When **DataSafe** is licensed, **Fraud Protection Service (FPS)** will display as **Licensed**. This is different than **WebSafe**, where Fraud Protection Services will show up as N/A.  **WebSafe** is now EoS and EoL and is no longer available.

.. image:: /_static/advwaf/image57.png
   :alt: Provisioning Page
   :align: center
   :width: 500

-  Expand the **Security** menu.  There should be a **Data Protection** option.

.. important::
   Data Protection did not initially show up on the PerAppWAF VE even thought licensed and provision.  You may only get the FPS option.  If this happens  re-activate the license and that should resolve the issue.
                                  
.. image:: /_static/advwaf/image58.png
   :alt: Data Protection option in TMUI
   :align: center
   :width: 400             

Task 2 – DataSafe Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. important::
   In v15.1.2.x there is an error in **Data Protection** TMUI interface **K28459181: Unable to create or update DataSafe profile after upgrade** https://support.f5.com/csp/article/K28459181 and **Data Protection** profiles must be built using TMSH. Upgrading to v15.1.3.x or higher resolves this issue. In this task you will be shown both the TMUI and TMSH instructions for building a DataSafe profile.

.. note::
   As the TMUI screenshots are shown for configuration, the TMSH boxes will show you the TMSH command being built to build the same profile.  You can choose to build via TMSH or upgrade to v15.1.3.

-  Open the **Security > Data Protection > DataSafe Profiles** page and click **Create**.

.. image:: /_static/advwaf/image60.png
   :alt: Creating a Data Protection profile
   :align: center
   :width: 500


-  For **Profile Name** enter **Hackazon-DS** and click **Create**

The highlighted TMSH portion of the command shows you the profile being created and uses the default antifraud profiles as the parent profile, just a creating the profile in the TMUI does.

.. admonition:: TMSH

   **create /security anti-fraud profile hackazon_ds defaults-from antifraud** urls add { /user/login { app-layer-encryption { add-decoy-inputs enabled remove-element-ids enabled } parameters add { password { encrypt enabled obfuscate enabled } username { identify-as-username enabled obfuscate enabled } } } }


On the left menu click **URL List**, and then click **Create**. If you don't see the menu, click on the **>** arrow.

.. image:: /_static/advwaf/image61.png
   :alt: Defining the URL to be protected
   :align: center
   :width: 500

-  For **URL Path** leave **Explicit** selected, and type **/user/login**.  
                 
.. image:: /_static/advwaf/image61a.png
   :alt: Defining the URL to be protected
   :align: center
   :width: 500

.. admonition:: TMSH

   create /security anti-fraud profile hackazon_ds defaults-from antifraud **urls add { /user/login** { app-layer-encryption { add-decoy-inputs enabled remove-element-ids enabled } parameters add { password { encrypt enabled obfuscate enabled } username { identify-as-username enabled obfuscate enabled } } } }

-  From the left panel click on the **>** to open addition parameter options and click on the **Parameters** page.

Remember from earlier you found that the username and password parameter names are **username** and **password**.

-  Create a new parameter named **username**, check the **Identify as Username** box and then click **Create**.

-  Create a second parameter named **password**, and then click **Create**.

-  Scroll to the right to view all the parameter options.

-  For the **username** parameter select the **Obfuscation** checkbox.

-  For the **password** parameter select the **Encrypt**, **Substitute
      Value**, and **Obfuscate** checkboxes.

- Click on **Save**

.. image:: /_static/advwaf/image62.png
   :alt: Configuring parameters
   :align: center
   :width: 500

.. admonition:: TMSH

   create /security anti-fraud profile hackazon_ds defaults-from antifraud urls add { /user/login { app-layer-encryption { add-decoy-inputs enabled remove-element-ids enabled } **parameters add { password { encrypt enabled obfuscate enabled } username { identify-as-username enabled obfuscate enabled } }** } }

-  From the left menu open the **Application Layer Encryption** page. Notice that most features are enabled by default.

-  Review the explanations for the different features.

-  Under **Advanced** select the **Add Decoy Inputs** and **Remove Element IDs** checkboxes, and then click **Create**.

.. image:: /_static/advwaf/image63.png
   :alt: Application Layer Encryption features
   :align: center
   :width: 500

.. admonition:: TMSH

   create /security anti-fraud profile hackazon_ds defaults-from antifraud urls add { /user/login **{ app-layer-encryption { add-decoy-inputs enabled remove-element-ids enabled }** parameters add { password { encrypt enabled obfuscate enabled } username { identify-as-username enabled obfuscate enabled } } } }

Now let's attach the DataSafe profile to a virtual server.

-  Open the **Virtual Server List** page and click **hackazon_vs**, and then open the virtual server **Security > Policies** page.

-  From the **Anti-Fraud Profile** list select **Enabled**.

-  From the **Profile** list box, select **hackazon-ds**, and  then click **Update.**

.. image:: /_static/advwaf/image64.png
   :alt: Attach the DataSafe profile to a virtual server
   :align: center
   :width: 500


Exercise 3 – Testing DataSafe Protection
----------------------------------------

Task 1 – Review the Protected Hackazon Login Page
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Open a **private** browser window and access the Hackazon login page
   -  AWS: http://<Bigip1VipEipTo100>/user/login
   -  UDF: http://hackazon.f5demo.com/user/login.

-  Right-click inside the **Password** field and select **Inspect Element** or **Inspect**.

   *Question:* What is the **required-name** value for this field?

.. image:: /_static/advwaf/image65.png
   :alt: Example of parameter obfuscation and decoy inputs
   :align: center
   :width: 500

   **Obfuscation** - Notice that the name of the password field (outlined in red) is now a long cryptic name and is changing about every 10 seconds. The same is true of the username field.

   **Add Decoy Inputs** – Notice that there are other random inputs being added (outlined in green). The number and order of these inputs is changing frequently.

-  In the developer tools window select the **Network** tab, then click the clear icon to delete any current requests.

-  On the login page enter any username and password you desire and click **Sign In**.

-  In the **Network** tab select the **/login?return_url=** entry, and then scroll down to the bottom of the **Headers** tab.

*Question:* What parameters were submitted?

*Question:* Do you see a username or password field?

*Question:* Do you see the username you submitted?

As you can see the username parameter (outlined in green) was obfucated, but not encrypted per the configuration.  On the other hand the password parameter (outlined in red) is encrypted.  In fact, each keystroke in the password field was encrypted as the password was typed in, defeating malware keyloggers as well as malware scraping the POST prior to it being encrypted.

.. image:: /_static/advwaf/image66.png
   :alt: Example of parameter obfuscation and decoy inputs
   :align: center
   :width: 500

**Obfuscation** – DataSafe obfuscates the names of the parameters when they are submitted in a login request.
**Encryption** – DataSafe encrypted the value of the password field so that it is not a readable value in the login request.

These two features together protect any sensitive parameter desired.  For example, these v                           protections could also be applied to a credit card number in a check out page.
