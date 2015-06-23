Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/salt/minion/doc/index` :doc:`/salt/minion/doc/pillar`

Mandatory
---------

Example::

  salt_cloud:
    master: localhost

.. _pillar-salt_cloud-master:

salt_cloud:master
~~~~~~~~~~~~~~~~~

Address of salt-master for all salt-cloud managed VMs.

Optional
--------

Example::

  salt_cloud:
    profiles:
      <profile_name>:
        <attribute_name>: <value>
    providers:
      <provider_name>:
        <attribute_name>: <value>

.. _pillar-salt_cloud-profiles:

salt_cloud:profiles
~~~~~~~~~~~~~~~~~~~

Dict of ``{profile_name: {attribute_name: value}}``, each dict contains data
to configure a salt-cloud profile.

Consult http://docs.saltstack.com/en/latest/topics/cloud/index.html#salt-cloud
for more information.

Default: ``{}``.

.. _pillar-salt_cloud-providers:

salt_cloud:providers
~~~~~~~~~~~~~~~~~~~~

Dict of ``{provider_name: {attribute_name: value}}``, each dict contains data
to configure a salt-cloud provider.

Consult http://docs.saltstack.com/en/latest/topics/cloud/index.html#salt-cloud
for more information.

Default: ``{}``.
