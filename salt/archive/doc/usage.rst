Usage
=====

When you author a formula or pillar file, you should get the package from the
file archive server first (if it was defined in the pillar), such as::

  {%- if salt['pillar.get']('files_archive', False) %}
  {{ salt['pillar.get']('files_archive', False) }}/pip/diamond-xxx.tar.gz
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

First, your :doc:`index` need to be a "master" server. It don't have to
act solely as a mirror and :doc:`/rsync/doc/index` to a source. That mean the
:ref:`pillar-salt_archive-source` pillar key must be undefined.

If a server got the pillar key :ref:`pillar-salt_archive-source` is defined, any
new files will be erased on next synchronization with the said source.

If your server don't have a source, an incoming folder is created for any
authorized users to upload new file.

To upload you have to copy the new file in ``incoming/pip`` (if it's a Python
package) or ``incoming/mirror`` directory on the server using
`SFTP <https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol>`_ with the
username ``salt_archive``.

The access to this user is granted using :doc:`/ssh/doc/index` keys, you have
your public key in :ref:`pillar-salt_archive-keys` pillar key.

Once your file is uploaded, after a while, a :doc:`/cron/doc/index` job run and
if the same file don't exists in ``pip/`` and ``mirror/`` it will move it if the
file don't already exists to avoid the same filename with different content.

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

Mirroring apt repository with apt-mirror
----------------------------------------

Another way to mirroring apt repository is using ``apt-mirror``.
Just fill the configuration file and then run ``apt-mirror path_to_config``,
it will mirror all files to ``/var/spool/apt-mirror/mirror``.  For example,
using bellow config file to mirror postgresql, say ``~/postgres_mirror``::

    set nthreads     20
    set _tilde 0
    deb-i386 http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
    deb-i386 http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
    deb-amd64 http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
    deb-amd64 http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main

Then run ``apt-mirror ~/postgres_mirror``, wait until it finish.
Afterwards, to keep only interested files, run bellow commands. Here keeps
just files relate to version 9.4 and remove unused software::

    cd /var/spool/apt-mirror/mirror/apt.postgresql.org/pub/repos/apt
    rm -r pool/main/p/{pgadmin3,pgloader,postgis}
    find . -name '*postgresql-*' ! -name '*postgresql-9.4*' -exec rm -r {} \;
