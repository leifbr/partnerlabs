F5 Channel SE - AWS Lab Environment
===================================
**(UNDER CONSTRUCTION)**
This environment is available for use by engineers wishing to build a lab environment in AWS using the provided AWS Cloud Formation Template (CFT) that is compatible with the labs available on this site or in the partnerlabs container available on http://docker.com.

.. IMPORTANT::
    Deploying this cloud formation template will incur cost. According to the AWS estimate it should be less than 0.50 USD per hour to run the lab using the defaults.  But you run this lab at your own risk.  I highly recommended budget reminders.

Some things to know when using the the **f5-aws-bigip-labs-vX.x** CFT template.  It is based off the 3nic PAYG learning stack found here: https://github.com/F5Networks/f5-aws-cloudformation/tree/master/experimental/standalone/3nic/learning-stack/payg

A big difference is the IP addressing is standardized (as much as possible) around the F5 Unified Demo Framework (UDF) and WWFR lab environments, so as to keep the lab guides consistent and simplified.  The other difference is that the BIG-IP can be brougt up unconfigured, except for basic set up, with only base networking configured, or, using the AS3 json scripts and basic networking configuration to bring up preconfigure virtual servers and pools for the lab environment.

I will probably not explain everything you need to know, especially if you haven't used AWS much, but I will give you the basics of using the template.

#. Clone the git respository to your device or just download the **f5_aws_bigip_labs-vX.x.yml** CFT template which can be found here: https://github.com/leifbr/partnerlabs/blob/master/awslab/f5-aws-bigip-labs-v1.0.yml 
#. Log in to your AWS account and your management console.
#. Search for CloudFormation (if you don’t already have it as a favorite) and click on CloudFormation
#. Select **Create Stack**
#. Select **Upload a template file** and hit the **Choose file** button.
#. Upload the **f5-aws-bigip-labs-vX.x.yml** and click **Next**
#. Most of the template is self explanatory or can be defaulted.

   #. Under **Stack name** enter a name for your stack.
   #. Under **NETWORKING CONFIRGUTION** select an AZ (Availability Zone).  Only **us east** AZs are available at this time.
   #. Under **INSTANCE CONFIGURATION**

      #. **BIG-IP Image Name** The default is **Best25Mbps** which allows you access to all the modules.  For LTM only labs you may be able to make do with GOOD25Mbps to save a bit of money.
      #. **Custom Image Id** When you select any BIG-IP image above you will build a BIG-IP using an AMI for BIG-IP v15.1.2.1.  If you would like to work under another version, or if the lab requires another version, you can enter the AMI for that BIG-IP image here and it will override the **BIG-IP Image Name** selection.
      #. You can default until **SSH Key**.  Select your SSH key pair you want to use. 
      #. Source Address(es) for BIG-IP management and web application access. Enter your source IP or subnet to restrict lab access.  When in doubt you can just enter **0.0.0.0/0** and open it up wide .
<<<<<<< HEAD

    .. IMPORTANT::
       You must have a key pair to utilitize the lab.  If you do not have a key pair, stop, and set one up.
 
   #. You can default until **BIG-IP BASE NETWORKING AND VIRTUAL SERVICE CONFIGURATION** here is where you will tell the BIG-IP how you want your lab set up.

      #. If you leave the defaults the BIG-IP will basically be a blank slate.  Yours to configure however you want.
      #. If you select **Yes** under **configBigipNet** the BIG-IP will be configured with the base networking for the labs (vlans, self IPs and default gateway)
      #. Under **AS3 Declaration URL** you can enter a link to the json that will configure your layer 4-7 services (pools, virtual servers, etc). 
      #. **CONSULT YOUR LAB GUIDE TO DETERMINE THE NETWORKING AND L4-7 SERVICES REQUIRED FOR YOUR LAB**

      ..IMPORTANT:
      If you enter an AS3 URL make sure **configBigipNet** is set to **Yes** or you will end up with no configuration on the BIG-IP.

#. Hit **NEXT** 
#. If will take a few minutes for the environment to spin up and a little longer for all the containers on the backend server to come up.
#. Once the stack is complete you can set up access to the BIG-IP.

   #. Select your stack and select **Output**.
   #. Find the **Bigip1ManagementEipAddress**. This is the Elastic IP (EIP) you will this to connect to the BIG-IP
   #. Using PuTTY or SSH and your keypair, SSH to the BIG-IP using your keypair.
   #. At the TMSH prompt enter:

   ..COMMAND:
   mod auth user admin password <your password> shell bash

   #. this will set the password for connecting to the TMUI (GUI) interface of the BIG-IP and allow the **admin** user to access the Linux CLI on the BIG-IP. This is the equivalent of giving a user **Advanced shell** privileges in the TMUI interface.
