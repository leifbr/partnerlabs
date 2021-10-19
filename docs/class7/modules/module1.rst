Setting up and Access the Lab Environment (AWS and UDF)
=======================================================

Basic Lab Environment
---------------------

The basic networking and lab enviroment for both AWS and UDF are shown below:

.. image:: /_static/101/vLabNG_Diagram_v1.png
   :alt: Lab Diagram
   :align: center
   :width: 500

**AWS - Accessing and Setting up the Lab Environment**
------------------------------------------------------
These instructions are specific to the AWS lab environment.

You will need specific inputs when building your AWS lab environment to have the BIG-IP set up and ready for the WAF lab.

Instructions on how to build the F5-AWS lab environment can be found here:  :ref:`building-the-aws-lab`

Once you load your AWS CFT template **f5-aws-bigip-labs.yml** and begin configuring you stack you will need to put specific criteria into the following fields so the lab will be read upon creation.

- In **INSTANCE CONFIGURATION** select **PerAppVeAwaf25Mbps**, which is less than 50 cents/hour, even if your free trial is expired.  Alternately, you can use the **BYOL** open if you have **BEST** licensing.

.. important::
   You must **Subscribe** to the image (see above) prior to creating the stack.

- In **BIG-IP Modules** you want to provision WAF (ASM/ADVWAF) and FPS (Datasafe) on the BIG-IP for the labs.  Enter **ltm:nominal,asm:nominal,fps:nominal**
- Under **BIG-IP BASE NETWORKING AND VIRTUAL SERVICE CONFIGURATION** 
   - For **configBigipNet** select **Yes**. This will build the base networking on the BIG-IP
   - For **AS3 Declaration URL** enter a URL pointing to the **advwaf-fundamentals.json** which will build the Hackazon virtual server and pool.  The easy way you can do this is by copying and pasting the following link: https://raw.githubusercontent.com/leifbr/partnerlabs/master/awslab/advwaf-fundamentals.json This link is obtained by going to https://github.com/leifbr/partnerlabs/blob/master/awslab/advwaf-fundamentals.json and selecting the **Raw** button.

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
under **ubu-Jumpbox** select **XRDP** and the screen size. Log on with
the credentials in the table above.

Now you will use BIG-IP declarative REST APIs to configure the BIG-IP prior to performing the labs.
  
- Open **Postman** on the UDF Jumpbox by clicking on the Postman icon in the launch panel at the botton of the screen.
.. image:: /_static/advwaf/image3.png
   :alt: Postman on the Launch panel
   :align: center
   :width: 500

Postman is an API platform for building and using APIs. Postman simplifies each step of the API lifecycle and streamlines collaboration so you can create better APIs—faster.  See Postman at https://postman.com 

- Select the **Advance WAF Fundamentals** collection on the side-bar.
.. image:: /_static/advwaf/image3a.png
   :alt: Postman
   :align: center
   :width: 500

You are going to use F5 declarative automation and orchestration tools to provision, network and configure the BIG-IP prior to beginning the Advance WAF lab by running a collection of JSON scripts against the BIG-IP REST API. 

.. image:: /_static/advwaf/image3b.png
   :alt: Advance WAF Fundamentals Postman collection
   :align: center
   :width: 500

**Task 1 - Base Network and Provision DO** uses Declarative Onboarding for base configuration and L1-3 networking configuration: https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/latest/.

**Task 2 - AdvWAF Fundamentals AS3** user Application Services v3 for the L7 configuration, creating the pool and virtual server you will be protecting: https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/.

You can review the JSON by selecting a task and the selecting **Body** undet the **Post** command.

- Run the collection by select the **View More Actions** icon to the left of the collect and then select **Run collection**.
.. image:: /_static/advwaf/image3c.png
   :alt: Run Postman collection
   :align: center
   :width: 500

- The **Runner** tab will pop up.  Select the **Run Advanced WAF Fundamentals** bottom to the right.
.. image:: /_static/advwaf/image3d.png
   :alt: Run Postman collections
   :align: center
   :width: 500

You should see HTTP success statuses (20x) come back for each collection.

.. image:: /_static/advwaf/image3e.png
   :alt: Postman
   :align: center
   :width: 500

.. important:: 
   Be patient.  Now is a good time to make a cup of coffee or tea.  It will take several minutes for the BIG-IP to fully configure.

- Check to ensure the BIG-IP built correct by:

  - Selecting **TMUI** from the **bigip01** access methods (see ::ref:`accessing-udf-lab` ) for more information and checking to make sure the virtual server is availa
  - From the jumpbox open a browser and go to http://hackazon.f5.com or http://10.1.10.100 
