Using Parent and Child WAF Policies
===================================

In this Lab we will apply WAF parent and child policies to protect the **Hackazon** Web Application.

The Environment
---------------
The BIG-IP networking and basic application components (virtual server and pool) have already been configured and the WAF components, **Application Security** and **Fraud Protection Service** have been provisioned.

The application you will be protecting is the OWASP Hackazon application used for security training.  A pool of two Hackazon applications named **hackazon-pool** using the members **10.1.20.20:80**, **10.1.20.21:80** and **10.1.20.22:80** and the default **http** monitor have been created and attached to the virtual server **hackazon-vs** with the destination IP address and port of **10.1.10.100:80**

Expected time to complete: **1 hour**

.. toctree::
   :maxdepth: 2
   :glob:

   lab*
