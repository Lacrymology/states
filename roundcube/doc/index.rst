RoundCube
=========

.. note::

  Consult :doc:`/mail/doc/index` for setting up a full-stack mail system.

.. TODO: Intro

To works properly, Roundcube need to have installed:

- :doc:`/postfix/doc/index`
- :doc:`/openldap/doc/index`
- :doc:`/dovecot/doc/index`

On the same **or** separate host, for this reason they can't be included by
other formulas. Roles and :doc:`pillar` need to define your mail architecture.

.. TODO: WRITE HERE ANYTHING SPECIFIC TO ROUNDCUBE FOR THOSE OTHER STATES

.. toctree::
    :glob:

    *
