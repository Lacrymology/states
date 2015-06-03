Troubleshoot
============

Permission Denied
-----------------

On the following::

  Permission denied (publickey).
  fatal: Could not read from remote repository.

  Please make sure you have the correct access rights
  and the repository exists.

It's probably

- The private key isn't specified in :doc:`pillar` :ref:`pillar-git_server-keys`
- User ``git`` isn't allowed in :doc:`/ssh/server/doc/pillar` of
  :doc:`/ssh/server/doc/index`.
