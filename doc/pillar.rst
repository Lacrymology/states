Global Pillars
==============

The following Pillar values are commonly used across all states.

Optional
--------

message_do_not_modify
~~~~~~~~~~~~~~~~~~~~~

Warning message to not modify file.

files_archive
~~~~~~~~~~~~~

Path to mirror/archive server where download most files (archives, packages,
pip) to apply states.

graylog2_address
~~~~~~~~~~~~~~~~

IP/Hostname of centralized Graylog2 server

graphite_address
~~~~~~~~~~~~~~~~

IP/Hostname of carbon/graphite server.

smtp
~~~~

Email server configuration.

Example::

  smtp:
    server: smtp.example.com
    port: 25
    domain: example.com
    from: joe@example.com
    user: yyy
    password: xxx
    authentication: plain
    tls: False

See below for details on each keys.

smtp:server
~~~~~~~~~~~

Your SMTP server. Ex: smtp.yourdomain.com

smtp:port
~~~~~~~~~

SMTP server port.

smtp:domain
~~~~~~~~~~~

Domain name to use.

smtp:from
~~~~~~~~~

SMTP account use in FROM field.

smtp:user
~~~~~~~~~

SMTP account username, if applicable.

smtp:password
~~~~~~~~~~~~~

Password for account login, if specified user.

smtp:authentication
~~~~~~~~~~~~~~~~~~~

Authentication method. Default is: `plain`.

smtp:tls
~~~~~~~~

Use TLS or Not. Default is: `False`.
