.. Copyright (c) 2013, Quan Tong Anh
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Quan Tong Anh nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Usage
=====

When you author a formula or pillar file, you should get the package from the
file archive server first (if it was defined in the pillar), such as::

  {%- if 'files_archive' in pillar %}
  {{ pillar['files_archive'] }}/pip/diamond-xxx.tar.gz
  {%- else %}
  git+git://github.com/BrightcoveOS/Diamond.git@xxx#egg=diamond
  {%- endif %}

Python Pip
----------

:doc:`/pip/doc/index` come with native support for the archive, if
``files_archive`` is defined it will automatically grab those files from it.
No need to specify the path in your ``requirements.txt``.

How to upload new files
-----------------------

First, your Salt Archive server need to be a "master" server. It don't have to
act solely as a mirror and rsync to a source. That mean the
``salt_archive:source`` pillar key must be undefined.

If a server got the pillar key ``salt_archive:source`` is defined, any
new files will be erased on next synchronization with the said source.

If your server don't have a source, an incoming folder is created for any
authorized users to upload new file.

To upload you have to copy the new file in ``incoming/pip`` (if it's a Python
package) or ``incoming/mirror`` directory on the server using
`SFTP <https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol>`__ with the
username ``salt_archive``.

The access to this user is granted using :doc:`/ssh/doc/index` keys, you have your public key in
``salt_archive:keys`` pillar key.

Once your file is uploaded, after a while, a cron job run and if the same file
don't exists in ``pip/`` and ``mirror/`` it will move it if the file don't
already exists to avoid the same filename with different content.

If file exists, it get removed.

Mirror an Ubuntu PPA
--------------------

To create such mirror run the following::

  mkdir -p /var/lib/salt_archive/mirror/$MIRROR_NAME/$VERSION
  cd /var/lib/salt_archive/mirror/$MIRROR_NAME/$VERSION
  wget -m -I /$PPA_USERNAME/$PROJECT_NAME/ubuntu/ http://ppa.launchpad.net/$PPA_USERNAME/$PROJECT_NAME/ubuntu/
  mv ppa.launchpad.net/$PPA_USERNAME/$PROJECT_NAME/ubuntu/dists ppa.launchpad.net/$PPA_USERNAME/$PROJECT_NAME/ubuntu/pool .
  rm -rf ppa.launchpad.net
  find . -type f -name 'index.*' -delete
  find pool/ -type f ! -name '*.deb' -delete

Replace the ``$PROJECT_NAME`` by the name of your choice.

.. note:: The name of the formula might be the best name.

Replace ``$VERSION`` for what is actual latest version of the PPA packages.
Or any version or codename that represent the repository status at this point.

Replace ``$PPA_USERNAME`` and ``$PROJECT_NAME`` by the value of PPA URL:

``https://launchpad.net/~PPA_USERNAME/+archive/ubuntu/PROJECT_NAME``
