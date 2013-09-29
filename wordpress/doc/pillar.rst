Pillar
======

Mandatory
---------

wordpress:
  hostnames:
    - list of hostname, used for nginx config
  title: Site title
  username: admin username
  admin_password: admin's password
  email: admin email

Optional
--------
wordpress:
  password:  password for mysql user "wordpress"
  public: site appear in search engines. Default is: 1 (yes)
  mysql_variant: Variation of the MySQL that you use. Default is MariaDB
  ssl: enabled ssl
  ssl_redirect: force redirect to ssl
  workers: the number of worker for running web service

