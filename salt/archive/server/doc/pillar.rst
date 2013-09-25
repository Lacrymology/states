Pillar
======

Mandatory 
---------

salt_archive:
  web:
    hostnames:
      - archive.example.com

salt_archive:web:hostnames
~~~~~~~~~~~~~~~~~~~~~~~~~~

list of hostname of the web archive

Optional 
--------

salt_archive:
  source: rsync://archive.robotinfra.com/archive/
  delete: True
  web:
    ssl: mykeyname
    ssl_redirect: True
  keys:
    00daedbeef: ssh-dss

salt_archive:source
~~~~~~~~~~~~~~~~~~~

rsync server used as the source for archived files.

salt_archive:web:ssl
~~~~~~~~~~~~~~~~~~~~

SSL key to use to secure this server archive

salt_archive:web:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if True, redirect all HTTP traffic to HTTPs.

salt_archive:keys
~~~~~~~~~~~~~~~~~

dict of keys allowed to log in user

This state also need the following pillar for rsync state:

rsync:
  uid: salt_archive
  gid: salt_archive
  'use chroot': yes
  shares:
    archive:
      path: /var/lib/salt_archive
      'read only': true
      'dont compress': true
      exclude: .* incoming

You can change the name 'archive' by something else. but you need to change your
files_archive pillar value accordingly.
