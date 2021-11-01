**LAB Environments:** Accessing/Building your F5 LAB Environment
================================================================
Currently there are guides to three lab environments where you can run the labs available on this site or create your own environment for your own study.  

These lab environments are:

* The **Unified Demo Framework (UDF)** F5's official lab and demo environment
   * This an *invitation only*  environment requires you work with you F5 field or channel engineer to schedule and obtain access and can be used for customer and partner training.
   * :ref:`accessing-udf-lab`
* The **World-Wide Field Readiness (WWFR)** vLab **partner only** found on https://downloads.f5.com 
   * This lab can run in your own environment, but requires VMWare ESX or Workstation. 
   * :ref:`accessing-wwfr-lab`
* The DYI F5-AWS Lab Created AWS using a CFT (Cloud Formation Template) is an unofficial pay-as-you-go (PaYG) environment that can be run by customer or partners in their own AWS environment.
   * This lab runs in AWS at a very nominal cost and can be easy set up and torn down as desired.
   * :ref:`building-the-aws-lab`

.. note::
   All labs use the same backend servers and IP addressing scheme.  Any custom build instructions or exceptions will be noted in the access section of the various lab guides.

.. toctree::
   :maxdepth: 1
   :glob:

   modules/module*

Lab Network Diagram
-------------------
   
This is a basic diagram for the IP addressing scheme and back end web services provided in all the labs.

.. image:: /_static/_intro/vLabNG_Diagram_v1.png
   :alt: Visio Diagram of Lab
   :width: 700
   :align: center
   