Pillar
======

Optional
--------

Example::

  pip:
    mirrors: True

pip:mirrors
~~~~~~~~~~~

Value: True/False
when file_archives is defined in pillar, this pillar item
specify whether or not to use Pypi as a failover if pkg is not available
in using files_archive.

Default: ``True`` by default of that pillar key.

pip:proxy_server
~~~~~~~~~~~~~~~

Value: proxy server address

Default: ``False`` by default of that pillar key.
