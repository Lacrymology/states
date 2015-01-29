Pillar
======

Mandatory
---------

Optional
--------

Example::

  squid:
    allow_srcs:
      - 192.168.1.0/24
    debug: False

squid:ports
~~~~~~~~~~~

list of port that :doc:`index` binds to

Default: only bind to default port (``[3128]``).

squid:debug
~~~~~~~~~~~

Default: turn off debug log (``False``).

squid:max_disk_filesize
~~~~~~~~~~~~~~~~~~~~~~~

Default: (``102400``) KB.

squid:cache_disk_size
~~~~~~~~~~~~~~~~~~~~~

Default: (``2000``) MB.

squid:allow_src_ips
~~~~~~~~~~~~~~~~~~~

List of IPs which allowed to use :doc:`index`. This can be a normal IP address
or :ref:`glossary-CIDR`.

Default: does not allow any source IPs (``[]``).

squid:allow_dst_domains
~~~~~~~~~~~~~~~~~~~~~~~

List of domains that :doc:`index` allowed to access to.

Default: does not allow any destination domain (``[]``).
