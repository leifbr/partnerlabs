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
These instructions are specific to the AWS lab environment.

You will need specific inputs when building your AWS lab environment to have the BIG-IP set up and ready for the WAF lab.

Instructions on how to build the F5-AWS lab environment can be found here:  :ref:`building-the-aws-lab`

Once you load your AWS CFT template **f5-aws-bigip-labs.yml** and begin configuring you stack you will need to put specific criteria into the following fields so the lab will be read upon creation.

1. In **INSTANCE CONFIGURATION** select **PerAppVeAwaf25Mbps**, which is less than 50 cents/hour, even if your free trial is expired.  Alternately, you can use the **BYOL** open if you have **BEST** licensing.

.. important::
   You must **Subscribe** to the image (see above) prior to creating the stack.

2. In **BIG-IP Modules** you want to provision WAF (ASM/ADVWAF) and FPS (Datasafe) on the BIG-IP for the labs.  Enter **ltm:nominal,asm:nominal,fps:nominal**
3. Under **BIG-IP BASE NETWORKING AND VIRTUAL SERVICE CONFIGURATION**
   
   a. For **configBigipNet** select **Yes**. This will build the base networking on the BIG-IP
   b. For **AS3 Declaration URL** enter a URL pointing to the **advwaf-fundamentals.json** which will build the Hackazon virtual server and pool.  The easy way you can do this is by copying and pasting the following link: https://raw.githubusercontent.com/leifbr/partnerlabs/master/awslab/advwaf-fundamentals.json This link is obtained by going to https://github.com/leifbr/partnerlabs/blob/master/awslab/advwaf-fundamentals.json and selecting the **Raw** button.

From here you can just complete the template per the :ref:`building-the-aws-lab` instructions.

.. important::
   When you are done with the lab **don't forget to DELETE the stack**.  This will clean up everything the stack built and you will incur no further charges.  You also have the option to just shut the images down to limit costs if you want to pick up where you left off.


Internal/External Access to the AWS Environment
-----------------------------------------------

You will only be able to access the AWS environment from your device using external IPs provided be AWS via the stack.  These external IPs (EIPs) our under the **Output** tab of the stack.

+-----------+-------------+--------------------------------------+-------------------+----------+----------------+
| Component | Access Type |           External Access            |  Internal Access  | Username |    Password    |
+===========+=============+======================================+===================+==========+================+
| bigip01   | SSH mgmt ip | <Bigip1ManagementEipAddress>         | 10.1.1.4          | admin    | <privatekey>   |
+-----------+-------------+--------------------------------------+-------------------+----------+----------------+
| bigip01   | GUI         | https://<Bigip1ManagementEipAddress> | https://10.1.1.4  | admin    | <yourpassword> |
+-----------+-------------+--------------------------------------+-------------------+----------+----------------+
| bigip01   | hackazon_vs | http://<Bigip1VipEipTo100>           | http://10.1.1.100 | admin    | hackmesilly    |
+-----------+-------------+--------------------------------------+-------------------+----------+----------------+
| webserver | SSH         | <WebserverPublicIp>                  | 10.1.20.100       | ubuntu   | <privatekey>   |
+-----------+-------------+--------------------------------------+-------------------+----------+----------------+
| webserver | Lab Guides  | http://<WebserverPublicIp>           | none              | none     | none           |
+-----------+-------------+--------------------------------------+-------------------+----------+----------------+

|
|

**Accessing and Setting up the UDF Lab Environment**
----------------------------------------------------

These instructions are specific to the UDF lab environment.

Basic instructions on accessing UDF course and be found here:  :ref:`_accessing_udf`

Accessing the Lab Images
------------------------

+----------------+-------------+------------+-----------+--------------+
| **Components** | **Mgmt IP** | **Access** | **User**  | **Password** |
+================+=============+============+===========+==============+
| bigip01        | 10.1.1.4    | GUI        | admin     | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+
|                | 10.1.1.4    | SSH        | root      | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+
| bigip02        | 10.1.1.5    | GUI        | admin     | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+
|                | 10.1.1.5    | SSH        | root      | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+
| ubu-jumpbox    | 10.1.1.6    | RDP        | f5student | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+
| LAMPNG         | 10.1.1.7    | SSH        | f5student | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+
|                | 10.1.1.7    | webmin     | f5student | f5UDFrocks!  |
+----------------+-------------+------------+-----------+--------------+

Accessing the Ubuntu Jumpbox
----------------------------

In the **Deployments** tab and select the **Access** drop down menu and
under **ubu-Jumpbox** select **XRDP** and the screen size similiar to the image below. Log on with
the credentials in the table above.

.. image:: /_static/101/image9.png


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

