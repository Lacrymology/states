Pillar
======

Mandatory
---------

Example:

  smtp:
    server: smtp.yourdomain.com
    port: 25
    root: joe@example.com
    mailname: example.com

smtp:server
~~~~~~~~~~~

Your SMTP server.

smtp:port
~~~~~~~~~

SMTP server port.

smtp:root
~~~~~~~~~

smtp:mailname
~~~~~~~~~~~~~

The system mail name should be your fully qualified domain name.

Optional
--------

Example:
  
  smtp:
    user: joe@example.com
    password: joepass
    tls: False

smtp:user
~~~~~~~~~

SMTP account username, if applicable.

Default: ``False``. If you defined it, you must define:

smtp:password - Password for account login, if specified user.

smtp:tls
~~~~~~~~

Use TLS or Not.

Default: ``False`` by default of that pillar key. 