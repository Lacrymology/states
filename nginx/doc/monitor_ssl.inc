|deployment|\_nginx_https
~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` https connection for |deployment|. See detail options for
this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

Critical: not receive response or receive unexpected return code.

|deployment|\_nginx_https_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` https connection for |deployment| using IPv6 address. See
detail options for this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

Critical: not receive response or receive unexpected return code.

|deployment|\_nginx_https_certificate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` :doc:`/ssl/doc/index` certificate status for |deployment|.
See detail options for this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

Crirital: not receive response or there is some problems with SSL certificate.


|deployment|\_ssl_configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` :doc:`/ssl/doc/index` configuration for |deployment|. See
detail options for this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is ``True``.

This check monitors:

* sslscore
* serverHostname
* validationResult
* expireInDays

Warning: score in range from 65 to 80

Critical: score in range from 0 to 65
