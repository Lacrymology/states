Configuration file
==================

Here're the common steps to setup :doc:`index`:

1. Install OpenVPN client:

   * Windows: https://openvpn.net/index.php/open-source/downloads.html
   * Debian/Ubuntu::

       apt-get install openvpn

   * OS X: https://code.google.com/p/tunnelblick/ or via Homebrew::

       brew install openvpn

   Other distributions can install via its own software repositories or from the
   source tarball.

2. Download the archive file that include a config file, secret key or
   `Certificate Authority <http://en.wikipedia.org/wiki/Certificate_authority>_`
   and client certificate depends on which authentication mode. They are
   located in ``/etc/openvpn/{{ instance }}`` on the OpenVPN server.

3. Unzip the above archive file, then copy the extracted files to the
   appropriate directory.

   * Windows: ``C:\Program Files\OpenVPN\config\``
   * Linux: ``/etc/openvpn``
   * OS X: ``/usr/local/etc/openvpn/``

4. Starting :doc:`index`:

   * Windows: Start Menu -> All Programs -> OpenVPN -> OpenVPN GUI
   * Linux/OSX::

       cd /path/to/openvpn
       openvpn client.conf
