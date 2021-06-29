Lab 6: Support and Troubleshooting
==================================

In this lab you will review your BIG-IP using iHealth and perform some
basic troubleshooting commands

Objective:

-  Get a QKView and upload it to http://ihealth.f5.com and review the
   results.

-  Perform a TCPDump to watch traffic flow.

-  Obtain web page information via Curl.

Archive the current configuration and perform a health check using a QKview
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Obtain a **QKView**. Go to **System > Support**

   a. Here under **System>Support>Manage iHealth Credentials** you can
      enter you iHealth (F5) credentials

c. From **System>Support** select the **New Support Snapshot** button to
   create a QKView

   a. From here you can create and upload a qkview, just create a qkview
      or create a TCPDump

   .. image:: /_static/101/image64.png
      :width: 4.13816in
      :height: 4.01299in

1. Import the QKView into iHealth if you did not automatically upload
   the QKview to iHealth.

d. Go to http://ihealth.f5.com. If you don’t have an account, now is the time to create one and then skip to the next section **Troubleshoot using TCPDump or Curl** because it will take time for your account set up.**

e. Select **Upload to iHealth** button and upload the QKView file you
   download from your BIG-IP

f. Once the file is uploaded you can click on the hostname to view you
   the heuristics.

   i.  Note the Diagnostics. Go to **Diagnostics > Critical** on the
       side-bar.

       1. Example: **The configuration contains user accounts with
          insecure passwords** is because we are using default
          passwords.

   ii. Select **Network > Virtual Servers**, then click on the small
       white triangles to expand the view or go to **Pools**, then
       **Pool Members** to continue to expand the view.

       1. This is a little more detailed than **Local Traffic > Network
          Map**

   .. image:: /_static/101/image65.png
      :width: 3.03774in
      :height: 2.13701in

g. Want to know interesting CLI commands, go to **Commands > Standard**
   and expand **tmsh** then **LTM** and click on **show /ltm virtual**
   toward the bottom.

h. Under **Files > config** you can view the **bigip.conf** file and see
   the command lines you used for you build.

   i. All the **log** files are here too

i. Feel free to just poke around.

Troubleshoot using TCPDump or Curl.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Go to your **www_vs (10.1.10.100)** virtual server and set **Source Address Translation** to **None**.

   a. Now browse the web site. You will not be able to access it even though
      the status of the virtual is available.

      i. Because BIG-IP is not the server’s default gateway the server's response goes around the BIG-IP.

   a. The web administrator tells you everything is fine as far as he
      can see and thinks the issue is with the BIG-IP, because they
      ALWAYS think the issue is with the BIG-IP.

   b. You begin by debugging the client connections to the web servers
      through the BIG-IP using TCPDump.

2. SSH to the management port of your BIG-IP. Remember the BIG-IP is a
   full proxy. You will need two TCP dumps and therefore two SSH windows for
   the client-side connection and the server-side connection.

   a. First let’s see what if we are hitting the virtual server. At the
      Linux CLI prompt:

      i. **tcpdump –i <client vlan name> host –X –s128 10.1.10.100 and
         port 80**

         1. This is a little overkill, but a good example of syntax. We
            will only look at traffic headed for the virtual server, we
            will see the first 128 bytes (-s128) in ASCII (-X).

   b. Go to your browser and attempt to access the virtual server. You
      should see something like this:

.. code::

   17:38:40.051122 IP 10.1.10.1.43932 > 10.1.10.100.http: S522853636:522853636(0) win 8192 <mss 1460,nop,wscale 2,nop,nop,sackOK>
   0x0000: 0ffe 0800 4500 0034 0a40 4000 4006 0699 ....E..4.@@.@...
   0x0010: 0a80 0a01 0a80 0aeb ab9c 0050 1f2a 1d04 ...........P.*..
   0x0020: 0000 0000 8002 2000 3d10 0000 0204 05b4 ........=.......
   0x0030: 0103 0302 0101 0402 ........
   17:38:40.051169 IP 10.1.10.100.http > 10.1.10.1.43932: S 245310500:245310500(0) ack 522853637 win 4380 <mss 1460,sackOK,eol>
   0x0000: 0ffe 0800 4500 0030 27ef 4000 ff06 29ed ....E..0'.@...).
   0x0010: 0a80 0aeb 0a80 0a01 0050 ab9c 0e9f 2424 .........P....$$
   0x0020: 1f2a 1d05 7012 111c 2a0e 0000 0204 05b4 .*..p...*.......
   0x0030: 0402 0000 ....
   17:38:40.053644 IP 10.1.10.1.43932 > 10.1.10.100.http: . ack 1 win 64240
   0x0000: 0ffe 0800 4500 0028 0a41 4000 4006 06a4 ....E..(.A@.@...
   0x0010: 0a80 0a01 0a80 0aeb ab9c 0050 1f2a 1d05 ...........P.*..
   0x0020: 0e9f 2425 5010 faf0 7018 0000 ..$%P...p...
   17:38:40.053648 IP 10.1.10.1.43932 > 10.1.10.100.http: P 1:416(415) ack 1 win 64240
   0x0000: 0ffe 0800 4500 01c7 0a42 4000 4006 0504 ....E....B@.@...
   0x0010: 0a80 0a01 0a80 0aeb ab9c 0050 1f2a 1d05 ...........P.*..
   0x0020: 0e9f 2425 5018 faf0 43c5 0000 4745 5420 ..$%P...C...\ GET.
   0x0030: 2f20 4854 5450 2f31 2e31 0d0a 486f 7374 /.HTTP/1.1..Host
   0x0040: 3a20 3130 2e31 3238 2e31 302e 3233 350d :.10.1.10.100.

c. From the dump you can see you are are hitting the virtual server.  Your original client IP is in the first line of
   the dump *16:44:58.801250 IP* **<client_ip>.41536** > **10.1.10.100.http:** going to the virtual server.  The dump clip shows the TCP three-way handshake between the client and the virtual server and the initial part of the request **GET/ HTTP/1.1 Host: 10.1.10.100**

1. In the second SSH window we will do an expanded **tcpdump** for the
   sake of interest.

   a. **tcpdump –i <server vlan name> -X –s128 host <client IP>**

   b. Hit your virtual server again. You see packets with your client IP heading for the servers. They just aren’t responding. So we could reasonably suspect a server issue.

2. First, let’s check to see if the server is responding to HTTP on port 80. On the BIG-IP in an SSH window:

   a. Do a **<ctrl-c>** to escape out of **tcpdump**, if you are still
      in it, and use **curl** to test the server.  You should get output akin to whats below.

.. code::
   
   curl –i <server ip of a pool member

You should get output akin to what is below. The **-i** switch tells **curl** to output the HTTP header information also.

.. code::

   [admin@ip-10-1-1-4:Active:Standalone] ~ # curl -i 10.1.20.11
   HTTP/1.1 200 OK
   Date: Tue, 29 Jun 2021 18:49:41 GMT
   Server: Apache/2.4.10 (Debian)
   X-Powered-By: PHP/7.0.17
   Cache-Control: no-cache
   Vary: Accept-Encoding
   X-COLOR: (null)
   Content-Length: 7819
   Content-Type: text/html; charset=UTF-8

   <!DOCTYPE html>
   <html lang="en">
     <head>
       <meta charset="utf-8">
       <meta http-equiv="X-UA-Compatible" content="IE=edge">
       <meta name="viewport" content="width=device-width, initial-scale=1">
       <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
       <title>F5 vLab | Home</title>
   

b. The server is responding to the BIG-IP when directly connected, but
   not through the virtual server. Sounds like the server is routing
   around the BIG-IP, which means the BIG-IP is not the default gateway.

Turn **SNAT Automap** back on the **www_vs** virtual server

