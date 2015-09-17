Pillar
======

.. warning::

  To not interfer with jobs that are executed with ``test/jenkins/build.sh``
  pillar key :ref`pillar-salt_master-reactor` must be set to ``False``.

.. include:: /doc/include/add_pillar.inc

- :doc:`/jenkins/doc/index` :doc:`/jenkins/doc/pillar`
- :doc:`/salt/cloud/doc/index` :doc:`/salt/cloud/doc/pillar`
- :doc:`/salt/master/doc/index` :doc:`/salt/master/doc/pillar`

Mandatory
---------

.. _pillar-salt_ci-agent_pubkey:

salt_ci:agent_pubkey
~~~~~~~~~~~~~~~~~~~~

SSH public key of ci-agent, who in charge of copying test result files
to CI server.

.. _pillar-salt_ci-agent_privkey:

salt_ci:agent_privkey
~~~~~~~~~~~~~~~~~~~~~

SSH private key of ci-agent.

Optional
--------

.. _pillar-salt_ci-ssh_port:

salt_ci:ssh_port
~~~~~~~~~~~~~~~~

SSH port to copy result files through and scanning host key.

Default: ``22``

Conditional
-----------

.. _pillar-salt_ci-host_key:

salt_ci:host_key
~~~~~~~~~~~~~~~~

Host key of CI host. Set this to avoid network failure which may happen
when ssh-keyscan gets host key of CI host when sending test result back
to CI server.

Default: auto scanning (``None``).
