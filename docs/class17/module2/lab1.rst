Create WAF logging profile
==========================
You will begin by creating a logging profile to associated with WAF policies to log all incoming requests.  In a production environment this would lead to information overload, but for the lab environment will be used for informational purposes.

#. Select **Security->Event Logs->Logging Profiles** then click **Create**
#. For **Profile Name** enter :guilabel:`waf_log`
#. Select the **Application Security, Dos Protection**, and **Bot Defense** checkboxes

   .. image:: ./images/image301.png
      :height: 200px

#. On the **Application Security** tab, for **Request Type** select **All requests**

   .. image:: ./images/image302.png
      :height: 150px

#. On the **DoS Protection** tab select the **Local Publisher** checkbox

   .. image:: ./images/image303.png
      :height: 150px

#. On the **Bot Defense** tab select all the checkboxes in the **Log Requests by Classification**. In **Log Requests by Mitigation Action** select **Alarm**, **CAPTCHA** and **Block**.

   .. image:: ./images/image304.png
      :height: 400px

#. Click **Create** and you should see a :guilabel:`waf_log` in the **Logging Profiles**

   .. image:: ./images/image305.png
      :height: 200px
