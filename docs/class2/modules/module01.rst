
BIG-IP® Local Traffic Manager (LTM) Lab Guide - Introduction
============================================================

This lab guide is designed for you to get an understanding of the BIG-IP
Local Traffic Manager (LTM) product. These labs can aid you in obtaining F5 certifications by helping you to understand concepts and processes in configuring an BIG-IP LTM.  This lab is updated for V15.1.2, but the basic concepts and configuration has not changed much since BIG-IP v11.5

Below you will find lab access base on the lab environment (UDF or AWS) you will be using.

.. IMPORTANT::
  **DO NOT CONFIGURE FROM THE FROM THE SCREENSHOTS AS THEY ARE NOT ALWAYS UPDATED AND MAY CONTAIN INACCURATE INFORMATION**

Lab Network Diagram
-------------------

.. image:: /_static/101/vLabNG_Diagram_v1.png
   :width: 7.23272in
   :height: 7.38005in

**UDF Lab User Info**
---------------------

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

..image:: 
  /_static/101/image9.png

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
