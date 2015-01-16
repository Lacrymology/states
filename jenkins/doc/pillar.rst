Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  jenkins:
    hostnames:
      - ci.example.com

.. _pillar-jenkins-hostnames:

jenkins:hostnames
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  jenkins:
    ssl: example_com
    ssl_redirect: True

.. _pillar-jenkins-ssl:

jenkins:ssl
~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-jenkins-ssl_redirect:

jenkins:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

Conditional
-----------

jenkins:job_cleaner
~~~~~~~~~~~~~~~~~~~

:doc:`index` user used for deleting old disabled jobs.

.. note::

  this user must have enough permission to delete job.

jenkins:job_cleaner:days_to_del
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Days for job to be considered as old and delete by jobs cleanup script.

Default: ``15`` days.

jenkins:job_cleaner:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's username

jenkins:job_cleaner:token
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's API token. Visit ``/user/USERNAME/configure`` to
get this value.
