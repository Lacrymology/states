strongSwan Client
=================

Android
-------

* Install :doc:`index` from `Google Play
  <https://play.google.com/store/apps/details?id=org.strongswan.android>`_
* Find the new :doc:`/strongswan/doc/index` application in the home screen and
  start it
* Tap on the "Add VPN Profile" button at the top-right corner
* Enter the details as follow and then tap "Save":

  * Profile Name: ``strongSwan VPN``
  * Gateway: the public IP address of the :doc:`/strongswan/server/doc/index`
  * Type: ``IKEv2 EAP (Username/Password)``
  * Username: the key of :ref:`pillar-strongswan-secret_types-type`
  * Password: the value of :ref:`pillar-strongswan-secret_types-type`
  * CA certificate: Uncheck "Select automatically"

    * Download the :ref:`glossary-CA` certificate from the
      :doc:`/strongswan/server/doc/index` to the workstation
    * Copy that certificate to the Android device by uploading to a web server,
      sending an email, or via a third-party app like Android File Transfer
    * Run the File Manager application, go to the download folder, tap on the
      certificate to import it

  Now in the :doc:`index`, at the :ref:`glossary-CA` certificate section, tap
  on the "Select certificate", go to the Imported tab, and select the
  certificate that has been imported.

* Tap on the profile (:doc:`/strongswan/doc/index` VPN) to connect
* The connection should now be established. A key symbol will also be displayed
  in the status bar at the top left of the screen.

To disconnect, run the :doc:`/strongswan/doc/index` application and select
Disconnect in the status area.

iOS
---

Import certfificate
~~~~~~~~~~~~~~~~~~~

* Download the :ref:`glossary-CA` certificate and the ios_cert.p12 to the
  workstation and send it via email.
* On the iOS device, tap on the attach files to install it.

Config VPN
~~~~~~~~~~

* Settings
* General
* VPN --> Add VPN Configuration:

  * Type: ``IPsec``
  * Description: ``strongSwan``
  * Server: the public IP address of the :doc:`/strongswan/server/doc/index`
  * Account: the key of :ref:`pillar-strongswan-secret_types-type`
  * Password: the value of :ref:`pillar-strongswan-secret_types-type`
  * Turn on "Use Certificate" and choose the client cert.
  * Save VPN Configuration
  * Moving the slide bar to the right to connect. If it is OK, the status should
    be "Connected" and a "VPN" symbol will be displayed in the status bar at
    the top left corner of the screen.

To disconnect, move the slide-bar to the left.

OS X
----

Import Certificate
~~~~~~~~~~~~~~~~~~

* Download the :ref:`glossary-CA` certificate and the ios_cert.p12 to the
  workstation
* Open the Keychain Access application
* Choose System keychain
* File --> Import Items --> choose :ref:`glossary-CA` certificate --> Always
  Trust
* File --> Import Items --> choose ios_cert.p12
* Expand the certificate, double click on the private key, set Access Control
  to "Allow all applications to access this item"

Config VPN
~~~~~~~~~~

* System Preferences
* Network
* Click on the plus sign to create a new service:

  * Interface: ``VPN``
  * VPN Type: ``Cisco IPSec``
  * Service Name: ``strongSwan``

* Create
* Enter the details as follow:

  * Server Address: the public IP address of the
    :doc:`/strongswan/server/doc/index`
  * Account name: the key of :ref:`pillar-strongswan-secret_types-type`
  * Password: the value of :ref:`pillar-strongswan-secret_types-type`
  * Authentication Settings: tick on Certificate and choose the client cert
    that has been imported --> OK
  * Apply then Connect

To disconnect, click on the icon in the status bar --> disconnect strongSwan.

Windows
-------

Import Certificate
~~~~~~~~~~~~~~~~~~

* Download the :ref:`glossary-CA` certificate to the workstation and rename to
  .crt.
* Start --> Search --> mmc (Microsoft Management Console) --> Yes
* File --> Add/Remove Snap-in
* Certificates --> Add --> select Computer account --> Next --> Local computer
  --> Finish --> OK
* Certificates (Local Computer) / Trusted Root Certification Authorities /
  Certificates
* More Actions --> All Tasks --> Import --> Next --> browse to the certificate
  file that has been downloaded --> Open --> Next --> Next --> Finish --> OK

Config VPN
~~~~~~~~~~

* Network and Sharing Center --> Set up a new connection or network
* Connect to a workplace --> Next --> Use my Internet connection (VPN):

  * Internet address: the public IP address of the
    :doc:`/strongswan/server/doc/index`
  * Destination name: ``strongSwan``
  * Select "Don't connect now, just set it up so I can connect later" --> Next
  * Username: the key of :ref:`pillar-strongswan-secret_types-type`
  * Password: the value of :ref:`pillar-strongswan-secret_types-type`
  * Create --> Connect now

To disconnect, click on the network icon on the taskbar, right click on the VPN
connection and choose Disconnect.

Linux
-----

CLI
~~~

* Install :doc:`/strongswan/server/doc/index`::

    apt-get install strongswan

* Change the ``/etc/ipsec.conf`` file as follow::

    conn strongswan
      right=the public IP address of the :doc:`/strongswan/server/doc/index`
      rightsubnet=0.0.0.0/0
      rightauth=pubkey
      rightid="gateway cert's subject"
      leftsourceip=%config
      leftauth=eap
      leftid=ubuntu
      eap_identity=the key of :ref:`pillar-strongswan-secret_types-type`
      auto=add

* Add username/password into the ``/etc/ipsec.secrets``::

    <username> : EAP "<password>"

  while <username> is the key of :ref:`pillar-strongswan-secret_types-type` and
  <password> is the value of :ref:`pillar-strongswan-secret_types-type`.

* Copy the :ref:`glossary-CA` certificate from the
  :doc:`/strongswan/server/doc/index` to ``/etc/ipsec.d/cacerts``.

* Connect by running::

    ipsec up strongswan

  If everything is OK, the following will appear at the end of the above output
  in the terminal::

    installing DNS server 8.8.8.8 to /etc/resolv.conf
    installing new virtual IP 172.16.0.129

  If not, look at the errors to troubleshoot.

* To disconnect, run the following command::

    ipsec down strongswan
