Lab 5: BIG-IP Policies and iRules
=================================

In your customers environment the web servers retrieve images from a
different set of servers. In the lab you will write and iRule and create
a BIG-IP policies so you can compare and contrast the to methods. iRules
are more flexible and customizable, while BIG-IP policies are easier to
use, require no coding skills and are a little more efficient when
performing the same task.

Write an iRule to retrieve images when an HTTP request is received
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When HTTP request is received, look at the HTTP URI. If the URI ends
with **jpg** or **png** send the request to an alternate pool of image
servers.

1. **Create** a new pool named **image_pool**, use the **http** monitor
   for status and add one member **10.1.20.14:80**.

2. Go to **Local Traffic > iRules > iRules List** and select the create
   button.

   a. **Names:** retrieve_images

   b. **Definition:**

..

   when HTTP_REQUEST {

   # If the content is a jpeg or portable graphic (png) go to the image
   pool

   if { ([HTTP::uri] ends_with "jpg") or ([HTTP::uri] ends_with "png") }
   {

   pool image_pool

   }

   }

c. Note the highlighted content, click on HTTP_REQUEST and HTTP::uri to
   get information on the event and command.

3. Go to **Local Traffic > Virtual Servers** and open the **secure_vs**
   virtual server. Go to the **Resources** section.

   a. Under **iRules** select the **Manage** button and put the
      **retrieve_images** iRule into the **Enabled** box and add the
      iRule to the virtual server.

      i. What other profile did this iRule require to work?

4. Test your policy by going to https://10.1.10.105, you will want to
   use an incognito/private browsing window to avoid cached content.

a. All you image content should come from Node 4 (10.1.20.14).

.. image:: /_static/101/image57.png
   :width: 3.0328in
   :height: 2.51948in

b. Where is non-image request go?

Use a BIG-IP Policy to retrieve images from a different pool 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this task you are going to the same thing as above, except you will
use a BIG-IP policy.

1. First you create your policy container and set your match strategy.
   Try to do this using the instructions, but a screen shot of the
   policy is available in the **Appendix** at the end of the lab guide
   if you would like it.

2. Go to **Local Traffic ›› Policies : Policy List** and select
   **Create**

   a. **Policy_Name:** access_image_pool

   b. **Strategy:** Execute **first** matching rule.

   c. **Create Policy**

..

   .. image:: /_static/101/image58.png
      :width: 2.67708in
      :height: 1.36123in

3. Now you can create/view policy rules. Select **Create**.

   a. **Name:** get_images

   b. In the box under **Match all the following conditions:** select
      the |image4| to the right of **All traffic**

      i. Use the top drop down menu to select **HTTP URI**, on the next
         line of dropdown boxes select:

         1. **extension ends_with any of <Add jpg & png>** at
            **request** time

   c. Under **Do the following when the traffic is matched:** build the
      following operation.

      i. **Forward Traffic** to **pool** **Common/image_pool** at
         **request** time.

..

   .. image:: /_static/101/image60.png
      :width: 5.22628in
      :height: 1.33333in

d. **Save**

4. The policy is saved in **Draft** form and is not available/update
   until **Published**. To publish the policy:

a. Select the **Save Draft Policy** drop-down menu and select **Save and
   Publish Policy**.

..

   .. image:: /_static/101/image61.png
      :width: 2.47917in
      :height: 1.75529in

5. Go to the **Resources** section of your **secure_vs** virtual server
   and select **Managed** over the **Policies** box.

a. Remove the **retrieves_images** irule from the virtual server.

b. Move **access_image_pool** for the **Available** box to the
   **Enabled** box.

..

   |image5| |image6|

6. Now test your change by browsing to
   `http://10.1.10.105 <http://10.128.10.105/>`__\ **.**

c. If your policy is working is working correctly all the images under
   **F5 Platform List** should be from **NODE #4**.

d. Other images are PNG images and have a different extension.

.. image:: /_static/101/image57.png
   :width: 2.01665in
   :height: 1.67532in
