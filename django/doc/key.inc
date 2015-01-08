Random string.

:doc:`/django/doc/index` `SECRET_KEY <https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key>`_.

.. note::

  If for any reason the password need to be retrieved after installation,
  use the custom salt module ``password.pillar`` and specify
  the pillar key name in format ``path:django_key``.
