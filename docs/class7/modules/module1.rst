Advanced WAF Fundamentals - v15.1

Lab Guide

Participant Hands-on Lab Guide

.. image:: /_static/advwaf/image1.png
   :align: center
   :width: 500

Lab Network Overview
====================

Each student will have a BIG-IP VE environment with IP addressing as
below:

.. image:: /_static/advwaf/image2.jpg
   :align: center
   :width: 500

Accessing the lab environment
=============================

a. Open a browser and go to the link assign to you b (where **X** is
      your student number)

b. Look for the **xubuntu-jumpbox-vxx**. You will use the xubuntu
      jumpbox for all the labs. (see below)

..

   .. image:: /_static/advwaf/image3.png
   :align: center
   :width: 500
   
c. You can click on **RDP** to RDP to the Xubuntu jumpbox or you can
   select the **CONSOLE** link and access the jumpbox via your browser.
   **The CONSOLE link requires you turn off pop-up blockers.**

..

   .. image:: /_static/advwaf/image4.png
      :alt: C:\Users\leifb\AppData\Local\Temp\SNAGHTML230ba94c.PNG
      :align: center
      :width: 500

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

