nginx_http
----------

Check nginx http connection for |deployment|. See detail options for
this check in :doc:`/nginx/doc/pillar`.

Critical: not receive response or receive unexpected return code.

nginx_https
-----------

Check nginx https connection for |deployment|. See detail options for
this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

Critical: not receive response or receive unexpected return code.


nginx_https_certificate
-----------------------

Check nginx SSL certificate status for |deployment|. See detail options for
this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

Crirital: not receive response or there is some problems with SSL certificate.


ssl_configuration
-----------------

Check nginx SSL configuration for |deployment|. See detail options for
this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

This check monitors:

* sslscore
* serverHostname
* validationResult
* expireInDays

Warning: score in range from 65 to 80

Critical: score in range from 0 to 65
