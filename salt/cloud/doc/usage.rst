Usage
=====

.. _salt_cloud-usage-new_minion:

Create new Minion
-----------------

.. note::

  This assume the pillars are already managed properly. As this document won't
  cover pillar management.

On the same host as the :doc:`/salt/master/doc/index`, use ``salt-cloud``
command-line with the ``-p`` argument followed by one of the profile name
specified in :ref:`pillar-salt_cloud-profiles`.

Based of :doc:`/salt/master/doc/index` reactor integration, you might need to
manually run ``state.highstate`` once new minion is created.