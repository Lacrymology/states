Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/ssh/client/doc/index` :doc:`/ssh/client/doc/pillar`

Optional
--------

.. _pillar-pip-trusted_hosts:

pip:trusted_hosts
~~~~~~~~~~~~~~~~~

List of trusted hosts - which :doc:`index` will install package from them
even without :ref:`glossary-HTTPS` or bad/self-signed :doc:`/ssl/doc/index`
certificate.

.. note::

  If :ref:`pillar-files_archive` is used, it will be automatically added as a
  trusted host.

Default: No trusted host (``[]``).

.. _pillar-proxy_server:

proxy_server
~~~~~~~~~~~~

Proxy server address.

Default: don't use proxy server (``False``).

Conditional
-----------

Example::

  pip:
    allow_pypi: True

.. _pillar-pip-allow_pypi:

pip:allow_pypi
~~~~~~~~~~~~~~

When :ref:`pillar-files_archive` is defined, if this pillar item not
setted/defined or has value ``False`` will make :doc:`index` use files_archive
as the pkg source.
When it setted to value ``True``, :ref:`pillar-files_archive` will act as
a fallback when pkg is not available in pypi official index.

There is no way to make pypi official index act as fallback for
:ref:`pillar-files_archive`
because of the way :doc:`index` 1.5.x handles pkg sources.
In which, index always be chosen as pkg source when that pkg is available in
both index and :ref:`pillar-files_archive` (provided by option ``find-links``).

Default: use :ref:`pillar-files_archive` as pkg source if available (``False``).

Only use if :ref:`pillar-files_archive` is defined.
