.. _building-the-aws-lab:

**DYI F5-AWS Lab** (Do-It-Yourself F5-AWS Lab Environment)
==========================================================
This environment is available for use by engineers wishing to build a F5 lab environment in AWS using a provided AWS Cloud Formation Template (CFT) that is compatible with the labs available on this site.  This lab guide is containerized and available on https://hub.docker.com/repository/docker/leifbr/partnerlabs or as an open lab environment for your own education.

..  warning::
    **Deploying this cloud formation template WILL INCUR COST.** According to the AWS estimate and billing from my own personal AWS account the average cost shold be around 0.50 USD per hour to run the lab using a BIG-IP VE Good edition, a Per-App-VE Advanced WAF or a BYOL BIG-IP.  *You run this lab at your own risk. Neither myself or F5 is responsible for any cost you incur.* **I highly recommended budget reminders**. 

Warning aside, we are all engineers and know how to take care of our lab environments.  The **DYI F5-AWS Lab** is easily terminated and cleaned up by simply hitting the delete stack button.  This will clean up everything the CFT created.

Some things to know when using the the **f5-aws-bigip-labs.yml** CFT template.  It is based off the 3nic PAYG learning stack found here: https://github.com/F5Networks/f5-aws-cloudformation/tree/master/experimental/standalone/3nic/learning-stack/payg

A big difference is the IP addressing is standardized (as much as possible) around the F5 Unified Demo Framework (UDF) and WWFR lab environments, to keep the lab guides consistent and simplified.  The other difference is that the BIG-IP can be brougt up unconfigured, except for basic set up, with only base networking configured, or, using the AS3 json scripts and basic networking configuration to bring up preconfigure virtual servers and pools for the lab environment.

I will probably not explain everything you need to know, especially if you haven't used AWS much, but I will give you the basics of using the template.  Even if you are unfamiliar with AWS, the CFT makes building and tearing down the lab environment fairly easy.

Prerequisites
-------------
- Subscribe to Ubuntu 18.04 LTS – Bionic for backend server at https://aws.amazon.com/marketplace/pp/prodview-pkjqrkcfgcaog
- Subscribe to the F5 BIG-IP Virtual Edition you will be using:

.. important::
   There is a **FREE TRIAL** once you subscribe for a BIG-IP from the AWS website:
   *Try one unit of this product for 30 days. There will be no software charges for that unit, but AWS infrastructure charges still apply. Free Trials will automatically convert to a paid subscription upon expiration and you will be charged for additional usage above the free units provided.*  Once the free trial has expired there is a hourly license charge for the BIG-IP instance you use, with the exception of the BYOL. Of course all instances incur EC2 costs.

   - F5 BIG-IP Virtual Edition - GOOD (PAYG, 25Mbps) at https://aws.amazon.com/marketplace/pp/prodview-lphsy6izllsmq (0.43/hr estimated EC2 and Licensing)
   - F5 BIG-IP Virtual Edition - BEST (PAYG, 25Mbps) at https://aws.amazon.com/marketplace/pp/prodview-v2lgyijcawiti **(1.77/hr estimated EC2 and Licensing)** Because of cost I recommend avoiding this one if possible.
   - F5 Per-App-VE Advanced WAF with LTM, IPI, TC (PAYG, 25Mbps) https://aws.amazon.com/marketplace/pp/prodview-7ykhgfdcrjazq (0.47/hr estimated EC2 and Licensing)
   - F5 BIG-IP VE - ALL (BYOL, 2 Boot Locations) - https://aws.amazon.com/marketplace/pp/prodview-73utu5c5sfyyc (0.40/hr estimate for EC2 charges, no licensing charges, can be used with evaluation keys)
  
Creating the stack
------------------

- Clone the git respository to your device or just download the **f5_aws_bigip_labs.yml** CFT template which can be found here: https://github.com/leifbr/partnerlabs/blob/master/awslab/
- Log in to your AWS account and your management console.
- Search for CloudFormation (if you don’t already have it as a favorite) and click on **CloudFormation**.
- Select **Create Stack** and **With new resources (standard)** from the drop-down.
- Select **Upload a template file** and hit the **Choose file** button.
- Upload the **f5-aws-bigip-labs.yml** from your PC and click **Next**
  
Most of the template is self explanatory or can be defaulted.

- Under **Stack name** enter a name for your stack.
- Under **NETWORKING CONFIGURATION** select an AZ (Availability Zone).
- Under **INSTANCE CONFIGURATION**
   - **BIG-IP Image Name** The default is **GOOD25Mbps** which allows you to learn the basics and is inexpensive, even if the free trial is expired. Or, select the image designated by the lab. All images selected here are v15.1.2.1. You must **subscribe** to the BIG-IP version you want prior to building the stack.
   - **Custom Image Id** When you select any BIG-IP image above you will build a BIG-IP using an AMI for BIG-IP v15.1.2.1.  If you would like to work under another version, or if the lab requires another version, you can enter the AMI for that BIG-IP image here and it will override the **BIG-IP Image Name** selection.
   - **BYOL License Key** if you have BIG-IP lab, evaluation or production VE license key you can enter it here and the BIG-IP will be licensed.
  
   .. important::
      You can retrieve your license key for future use by **revoking** the license on the BIG-IP prior to deleting the stack.

   .. note::
      Custom AMI versions 13.x and lower must be licensed manually after the lab comes up.

   - You can default until **SSH Key**.  Select your SSH key pair you want to use. 

   .. important::
      **You must have a key pair to utilitize the lab.**  If you do not have a key pair, stop, and set one up.

   - Source Address(es) for BIG-IP management and web application access. Enter your source IP or subnet to restrict lab access.  When in doubt you can just enter **0.0.0.0/0** and open it up wide .
   - You can default until **BIG-IP Modules**.  The default is to provision LTM only, but you can provision other modules on boot as needed.
   
   - **BIG-IP BASE NETWORKING AND VIRTUAL SERVICE CONFIGURATION** here is where you will tell the BIG-IP how you want your lab set up. **If you leave the defaults the BIG-IP will basically be a blank slate.**  Yours to configure however you want.
      - If you select **Yes** under **configBigipNet** the BIG-IP will be configured with the base networking for the lab (vlans, self IPs and default gateway).  Your lab guide may require networking to be preconfigured.
      - Under **AS3 Declaration URL** you can enter a link to an AS3 json file that will configure your layer 4-7 services (pools, virtual servers, etc) as designated by the lab guide. Or, you can build your own AS3 json declaration and use it.

      .. important::
         If you are doing a predesign lab **BE SURE TO CONSULT YOUR LAB GUIDE TO DETERMINE THE NETWORKING AND L4-7 SERVICES REQUIRED FOR YOUR LAB**

      .. warning::
         If you enter an AS3 URL make sure **configBigipNet** is set to **Yes** or you will end up with no configuration on the BIG-IP.

- Hit **NEXT** 
- If will take a few minutes for the environment to spin up and a little longer for all the containers on the backend server to come up.

Establishing access to the BIG-IP
---------------------------------

- Once the stack build has complete you can set up access to the BIG-IP.
   - Select your stack and select **Output**.
   - Find the **Bigip1ManagementEipAddress**. This is the Elastic IP (EIP) you will use to connect to the BIG-IP management SSH and TMUI (GUI) components.  Only port 22 (SSH) and 443 (HTTPS) are open.
   - Using PuTTY or SSH and your keypair, SSH to the BIG-IP.
   - At the TMSH prompt enter:

   .. admonition:: TMSH
     
     mod auth user admin password <your password> shell bash

This will set the password for connecting to the TMUI (GUI) interface of the BIG-IP and allow the **admin** user to access the Linux CLI on the BIG-IP. This is the equivalent of giving a user **Advanced shell** privileges via the TMUI interface.

- Go to the **Bigip1MgmtUrl** in **Outputs** tab of the stack (same as https://<Bigip1ManagementEipAddress>) and log into the TMUI with **admin** and your new password.  Basic set up has already been performed.

.. note:: 
   If you are using an evaluation key or BYOL key you may have to activate the license the BIG-IP.

- Verify the containers are up and running by accessing this lab guide container on the back end server by going to the link **WebserverPublicUrl** in the **Outputs**.
- From **Outputs** make note of the following
   - **Bigip1VipEip100** you will use this address to access any virtual server with the private IP (Bigip1VipPrivateIp100) of **10.1.10.100**
   - **Bigip1VipEip105** you will use this address to access any virtual server with the private IP (Bigip1VipPrivateIp105) of **10.1.10.105**

Of course you can always refer back to the stack **Outputs** for this information.

**Congratulations!**  You are now ready to begin the labs.

Deleting the Lab Environment (AWS Stack)
----------------------------------------

.. important::
   When using a **BYOL** or an **evaluation key** remember to **REVOKE** your license prior to deleting the stack.  The license can then be re-used to license the next stack you build.

You can stop the EC2 BIG-IP and Webserver EC2 instances to reduce AWS charges and retain you environment as is.

When you delete the stack on the CloudFormation page all AWS objects built by the template will be removed.

If you do decide to delete the stack consider the following:

- If you are not done you can save you work via an UCS archive of the BIG-IP, download it to your PC, recreate the stack later and upload and restore the UCS archive.
- If you are using evaluation key or BYOL key you can **Revoke** the license and the key can be used again.  For evaluation keys that will be 30 or 45 days (depending on the key) after you first activated the key.
