Pillar
======

Mandatory 
---------

mysql:
  password: root_plaintext_password

mysql:password
~~~~~~~~~~~~~~

root password used for installation process, change this after
MariaDB installed does not make sense.

Optional 
--------

mysql:
  utf8: True/False
  bind: 0.0.0.0

mysql:utf8
~~~~~~~~~~

Enable or disable charset utf8. If disable, Latin1 charset will be
used. Default: False

mysql:bind
~~~~~~~~~~

what IP does MariaDB server will bind to. Default: 0.0.0.0
