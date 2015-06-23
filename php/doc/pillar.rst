Pillar
======

Optional
--------

Example::

    php:
      max_input_vars: 1000
      error_reporting: E_ALL & ~E_DEPRECATED & ~E_STRICT


php:version
~~~~~~~~~~~

Which version of :doc:`index` to install.

Possible values:

* Precise

  * ``5.4`` (default)
  * ``5.6``

* Trusty

  * ``5.5`` (default)
  * ``5.6``

Default: depends on Ubuntu release (``None``).

.. warning::

   Switching between :doc:`index` versions is not supported.

.. _pillar-php-max_input_vars:

php:max_input_vars
~~~~~~~~~~~~~~~~~~

How many ``GET/POST/COOKIE`` input variables may be accepted.  Use of this
directive mitigates the possibility of denial of service attacks which use hash
collisions. If there are more input variables than specified by this directive,
an ``E_WARNING`` is issued, and further input variables are truncated from the
request.

Default: allow no more than ``1000`` input variables.

.. _pillar-php-error_reporting:

php:error_reporting
~~~~~~~~~~~~~~~~~~~

Set the `error reporting level <http://php.net/error-reporting>`_.

Common Values:
Default Value: ``E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED``
Development Value: ``E_ALL``
Production Value: ``E_ALL & ~E_DEPRECATED & ~E_STRICT``

Default: ``E_ALL & ~E_DEPRECATED & ~E_STRICT``.
