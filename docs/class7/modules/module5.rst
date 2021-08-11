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

   .. image:: /_static/advwaf/image51.png
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

   .. image:: /_static/advwaf/image57.png
      :width: 5.02014in
      :height: 0.30694in

-  Expand the **Security** menu.

..

   There is a **Data Protection** option. This is different than WebSafe
   where this menu option is

Fraud Protection Service. DataSafe
                                  

   .. image:: /_static/advwaf/image58.png
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

.. image:: /_static/advwaf/image62.png
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

.. image:: /_static/advwaf/image65.png
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

.. |image1| image:: /_static/advwaf/image50.png
   :width: 2.69583in
   :height: 0.45417in
.. |image2| image:: /_static/advwaf/image52.jpeg
   :width: 3.87222in
   :height: 2.70208in
.. |image3| image:: /_static/advwaf/image53.png
   :width: 6.02083in
   :height: 0.80417in
.. |image4| image:: /_static/advwaf/image54.png
   :width: 5.3875in
   :height: 0.35417in
.. |image5| image:: /_static/advwaf/image55.png
   :width: 2.32917in
   :height: 1.23403in
.. |image6| image:: /_static/advwaf/image56.png
   :width: 4.47847in
   :height: 0.81875in
.. |image7| image:: /_static/advwaf/image60.png
   :width: 1.8625in
   :height: 0.75972in
.. |image8| image:: /_static/advwaf/image61.jpeg
   :width: 5.26528in
   :height: 0.90417in
.. |image9| image:: /_static/advwaf/image63.png
   :width: 2.42917in
   :height: 1.3625in
.. |image10| image:: /_static/advwaf/image64.jpeg
   :width: 3.6375in
   :height: 0.6375in
.. |image11| image:: /_static/advwaf/image66.png
   :width: 2.02083in
   :height: 1.22083in
.. |image12| image:: /_static/advwaf/image67.png
   :width: 2.6875in
   :height: 0.45417in
