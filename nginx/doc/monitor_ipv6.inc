|deployment|\_nginx_http_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` http connection for |deployment| using IPv6 address . See
detail options for this check in :doc:`/nginx/doc/pillar`.

Critical: not receive response or receive unexpected return code.

|deployment|\_nginx_https_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` https connection for |deployment| using IPv6 address. See
detail options for this check in :doc:`/nginx/doc/pillar`.

This check is only enabled if ``pillar_prefix:ssl`` is True.

Critical: not receive response or receive unexpected return code.
