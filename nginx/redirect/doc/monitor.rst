Monitor
=======

Mandatory
---------

redirect_nginx_http_{{ hostname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check HTTP connection of redirected ``{{ hostname }}``.

Critical: not receive response or receive unexpected return code.

redirect_remote_http_{{ hostname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check HTTP connection of remote ``{{ hostname }}``.

Critical: not receive response or receive unexpected return code.

Optional
--------

redirect_nginx_https_{{ hostname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check HTTPs connection of redirected ``{{ hostname }}``. Only available if SSL
is turn on.

Critical: not receive response or receive unexpected return code.


redirect_remote_https_{{ hostname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check HTTPs connection of remote ``{{ hostname }}``. Only available if SSL is
turn on.

Critical: not receive response or receive unexpected return code.

redirect_nginx_https_certificate_{{ hostname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check status of HTTPs cerfiticate of ``{{ hostname }}``. Only available if SSL
is turn on.

redirect_ssl_configuration_{{ hostname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check configuration of SSl for ``{{ hostname }}``. Only available if SSL is turn
on.
