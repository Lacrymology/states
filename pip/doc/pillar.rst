Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/ssh/client/doc/index` :doc:`/ssh/client/doc/pillar`

Optional
--------

Example::

  pip:
    allow_pypi: True

.. _pillar-pip-allow_pypi:

pip:allow_pypi
~~~~~~~~~~~~~~

When ``files_archive`` is defined in pillar, if this pillar item not
setted/defined or has value ``False`` will make pip use files_archive
as the pkg source.
When it setted to value ``True``, ``files_archive`` will act as
a fallback when pkg is not available in pypi offical index.

There is no way to make pypi offical index act as fallback for ``files_archive``
because of the way pip 1.5.x handles pkg sources.
In which, index always be choosen as pkg source when that pkg is available in
both index and ``files_archive`` (provided by option ``find-links``).

Default: use :ref:`pillar-files_archive` as pkg source if available (``False``).

.. _pillar-proxy_server:

proxy_server
~~~~~~~~~~~~

Proxy server address.

Default: don't use proxy server (``False``).
