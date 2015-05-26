Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`

Mandatory
---------

Example::

  git-server:
    keys:
      - ssh-dss 00deadbeefsshkey
    repositories:
      myreponame:
        push_notification: False

.. _pillar-git-server-keys:

git-server:keys
~~~~~~~~~~~~~~~

List of SSH public keys to grant access to :doc:`/git/doc/index` repository.

.. _pillar-git-server-repositories:

git-server:repositories
~~~~~~~~~~~~~~~~~~~~~~~

List of all repo handled by the server.  On first run, repo are
created as `"bare"
<http://git-scm.com/book/en/v2/Git-on-the-Server-Getting-Git-on-a-Server>`_
and need to be pushed into.
