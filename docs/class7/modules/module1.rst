Setting up and Access the Lab Environment (AWS and UDF)
=======================================================

Basic Lab Environment
---------------------

The basic networking and lab enviroment for both AWS and UDF are shown below:

.. image:: /_static/101/vLabNG_Diagram_v1.png
   :height: 7.38005in
   :width: 7.23272in
   :alt: Lab Diagram

**AWS - Accessing and Setting up the Lab Environment**
------------------------------------------------------

/class1/modules/module3.html

**Accessing and Setting up the UDF Lab Environment**
----------------------------------------------------

Accessing the Lab Images
------------------------

+------------------+-------------+------------+------------+--------------+
| **Components**   | **Mgmt IP** | **Access** | **User**   | **Password** |
+==================+=============+============+============+==============+
| bigip01          |  10.1.1.4   | GUI        | admin      | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+
|                  |  10.1.1.4   | SSH        | root       | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+
| bigip02          |  10.1.1.5   | GUI        | admin      | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+
|                  |  10.1.1.5   | SSH        | root       | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+
| ubu-jumpbox      |  10.1.1.6   | RDP        | f5student  | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+
| LAMPNG           |  10.1.1.7   | SSH        | f5student  | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+
|                  |  10.1.1.7   | webmin     | f5student  | f5UDFrocks!  |
+------------------+-------------+------------+------------+--------------+

Accessing the Ubuntu Jumpbox
----------------------------

In the **Deployments** tab and select the **Access** drop down menu and
under **ubu-Jumpbox** select **XRDP** and the screen size similiar to the image below. Log on with
the credentials in the table above.

.. image:: /_static/101/image9.png

**AWS Lab User Info**
---------------------

Accessing the images
--------------------

+------------------+----------+----------+------------+--------------+
| **Components**   | **Mgmt** | **       | **         | **Password** |
|                  |  **IP**  | Access** | Username** |              |
+==================+==========+==========+============+==============+
| bigip01          | 10.1.1.4 | GUI      | admin      | <yourpasswd> |
+------------------+----------+----------+------------+--------------+
|                  | 10.1.1.4 | SSH      | admin      | <privatekey> |
+------------------+----------+----------+------------+--------------+
| webserver        | 10.1.1.7 | SSH      | ubuntu     | <privatekey> |
+------------------+----------+----------+------------+--------------+


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

