OpenVPN Client
==============

Here're the common steps to setup :doc:`index`:

1. Install :doc:`index`:

   * Windows: https://openvpn.net/index.php/open-source/downloads.html
   * Debian/Ubuntu::

       apt-get install openvpn

   * OS X:

     - Homebrew::

         brew install openvpn

     - `Tunnelblick <https://code.google.com/p/tunnelblick/>`_

   Other distributions can install via its own software repositories or from
   the source tarball.

2. Download the zip file that include a config file, secret key or
   :ref:`glossary-CA` and client certificate depends on which authentication
   mode. They are located in ``/etc/openvpn/{{ instance }}/clients`` on the
   :doc:`/openvpn/doc/index` server.

3. Unzip the above archive file, then copy the extracted files to the
   appropriate directory.

   * Windows: ``C:\Program Files\OpenVPN\config\``
   * Linux: ``/etc/openvpn``
   * OS X:

     - Homebrew:  ``/usr/local/etc/openvpn/``

     - Tunnelblick: ``~/Library/Application\
       Support/Tunnelblick/Configurations``

4. Starting :doc:`index`:

   * Windows: Start Menu -> All Programs -> OpenVPN -> OpenVPN GUI
   * Linux::

       cd /path/to/openvpn
       sudo openvpn client.conf

   * OSX:

     - Homebrew: same as Linux.

     - Tunnelblick: click Tunnelblick icon on the top right corner, then
       Connect <client name>.
