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

1. Go to your virtual server and refresh server times. Note the color of the borders and pictures and 12 digit lpha-numeric code. These change depending on the server the connection for that particular request is load balanced too.

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

a. Log onto the CLI of your BIG-IP via SSH.

b. At the CLI go into **tmsh** at the **(tmos)#** prompt

c. At the shell prompt enter **show ltm profile ramcache www-opt-caching**

HTTP Optimization - HTTP Compression Lab
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before starting this lab, go to the main page for the **F5 vLab** demo application and select the **Demos** drop down menu from the top and then **Request and Response Headers**.

.. image:: /_static/101/image49a.png
   :alt: Demos drop-down :menuselection:
   :scale: 20
   :align: center

You'll note the browser is sending an **accept-encoding** header telling the server how to compress data to send back to the browser.  Without the **accept-encoding** header the server will not compress content even if the server is programmed to do so.

.. image:: /_static/101/image49b.png
   :alt: Demos drop-down :menuselection:
   :scale: 25
   :align: center

1. Go to **Local Traffic>Profiles>Service>HTTP Compression** or
   **Acceleration>Profiles>Web Acceleration**

.. hint::
   There are so many **Services** profile that the top of the pop-up will be invisible from the browser window.  In that case you can simply select **Local Traffic>Profiles>Services** and then select the **Services** drop down from the top bar to get to all the profiles.

         a. We are going to do anything fancy.  Create a new profile, **www-compress** using the
         **wan-optimized-compression** default profile.
   
2. Open up your **www_vs** virtual server.

a. At the **HTTP Profile** drop down menu make sure **http** is
   selected.

b. At the **Web Acceleration** drop down menu select **None**

   - *For purpose of this lab we don’t want caching interfering with our response headers*.

c. At the **HTTP Compression** drop down menu select the HTTP compression profile you just created

2. Now hit the F5 vLab web page and perform several <CTRL+F5> commands to refresh the content.

   a. Now off to the statistics on the sidebar, under the **Local Traffic** drop down menu select **Profiles Summary**

   b. Select the **View** link next to the **HTTP Compression** profile
      type.  Here you will see F5 compressing appropriate content prior to return the request.

.. image:: /_static/101/image50.png
   :width: 2.71523in
   :height: 1.8in

c. Go to the main page for the **F5 vLab** demo application and select the **Demos** drop down menu from the top and then **Request and Response Headers**. Notice you no longer see the **Accept-Encoding** header in the **Request Headers Received at the Server** section.  The BIG-IP essentially turned off server compression without any changes to the server by stripping out the **accept-encoding** header as the BIG-IP sent the request to server.

Archive your work in a file called: **lb4_acceleration**