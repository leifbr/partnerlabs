Lab 3: Accelerating Applications Lab
====================================

Objectives:

-  Assign client-side and server-side profiles

-  Set up caching for your web site

-  Set up compression for your web site

Lab Prerequisites:

-  Prior to starting this lab remove the cookie persistence profile from
   you virtual server.

TCP Express
~~~~~~~~~~~

1. Set clientside and serverside TCP profiles on your virtual server
   properties.

a. If you chose to use the **Advaced** menu you will see a whole array
   of new options. There are **Basic** and **Advanced** drop downs on
   many of the GUI menus. You can always see **Advanced** menus by
   changing the preferences in **System>Preferences.**

b. From the dropdown menus place the **tcp-wan-optimized** profile on
   the client-side and the **tcp-lan-optimized** profile on the
   server-side.

..

   .. image:: /_static/101/image46.png
      :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML30460794.PNG
      :width: 5.59375in
      :height: 4.70384in

HTTP Optimization - RamCache Lab
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Go to your virtual server and refresh server times. Note the Source
   Node for the pictures of the BIG-IPs. They change depending on where
   the connection is coming from. The Source Node information is part of
   the picture.

2. Go to **Local Traffic>Profiles>Services>Web Acceleration** or
   **Acceleration>Profiles>Web Acceleration**

a. Create a new profile named **www-opt-caching** using
   **optimized-caching** as the Parent Profile.

b. Take all the defaults, no other changes are required.

3. Open up your **www_vs** virtual server.

a. At the **HTTP Profile** drop down menu make sure **http** is
   selected.

b. Under **Acceleration** at **Web Acceleration** **Profile** select
   your new caching profile; **www-opt-caching**

c. Clear the statistics on your pool and the refresh the main web page
   several times.

   i.  The pictures do not change. Why do you think that is?

   ii. Go to your pool. Are all pool members taking connections?

4. Now go to **Statistics>Module Statistics>Local Traffic** on the
   sidebar, from the **Statistics Type** drop down menu select
   **Profiles Summary**

.. image:: /_static/101/image47.png
   :alt: C:\Users\RASMUS~1\AppData\Local\Temp\SNAGHTML1165ae63.PNG
   :width: 3.55238in
   :height: 2.125in

5. Select the View link next to the **Web Acceleration** profile type

.. image:: /_static/101/image48.png
   :width: 1.91667in
   :height: 1.20833in

.. image:: /_static/101/image49.png
   :width: 4.45349in
   :height: 1.26124in

6. You can get more detailed information on ramcache entries at the CLI
   level

a. Log onto the CLI of your BIG-IP via SSH using the root account (user:
   **root** password: **f5UDFrocks!**).

b. At the CLI go into **tmsh** at the **(tmos)#** prompt

c. At the shell prompt enter **show ltm profile ramcache
   www-opt-caching**

HTTP Optimization - HTTP Compression Lab
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Go to **Local Traffic>Profiles>Service>HTTP Compression** or
   **Acceleration>Profiles>Web Acceleration**

   a. Create a new profile, **www-compress** using the
      **wan-optimized-compression** default profile.

2. Open up your **www_vs** virtual server.

a. At the **HTTP Profile** drop down menu make sure **http** is
   selected.

b. At the **Web Acceleration** drop down menu select **None**

   i. *For purpose of this lab we don’t want caching interfering with
      our response headers*.

c. At the **HTTP Compression** drop down menu select the HTTP
   compression profile you just created

2. Now hit your virtual server and on the web page under **Content
   Examples on This Host** select the **HTTP Compress Example** and
   **Plaintext Compress Example** link.

   a. Now off to the statistics on the sidebar, under the **Local
      Traffic** drop down menu select **Profiles Summary**

   b. Select the **View** link next to the **HTTP Compression** profile
      type

.. image:: /_static/101/image50.png
   :width: 2.71523in
   :height: 1.8in

c. On the web page under, **HTTP** **Request and Response Information**
   select the **Request and Response Headers** link. Notice you no
   longer see the **Accept-Encoding** header in the **Request Headers
   Received at the Server** section.

   i. Alternately you can right click in the Chrome window and select
      **Inspect**

      1. Select **Network** from the top bar in the Inspect window.

      2. Refresh the page and select the **.php** pager and **Headers**
         on the bar to the right.

..

   .. image:: /_static/101/image51.png
      :width: 2.92178in
      :height: 1.45833in

d. You can also browse directly to one to the pool members, to help you
   find what has changed.

Archive your work in a file called: **lb4_acceleration**
