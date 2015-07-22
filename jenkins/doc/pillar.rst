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
    job_cleaner:
      username: cleaner
      token: JENKINS_APITOKEN_FOR_CLEANER
    gitconfig:
      git.example.com: gitlab
      github.com: git


.. _pillar-jenkins-gitconfig:

jenkins:gitconfig
~~~~~~~~~~~~~~~~~

Map of address to user that will be used in gitconfig file of jenkins
user. By setting this, a :doc:`index` job can run ``go get`` shell command
against repositories from configured addresses. This support targets mainly
:doc:`/go/doc/index` user.

Default: do not provide gitconfig (``{}``).

.. _pillar-jenkins-job_cleaner:

jenkins:job_cleaner
~~~~~~~~~~~~~~~~~~~

:doc:`index` user used for deleting old disabled jobs.

.. note::

  this user must have enough permission to delete job.

Default: does not use ``False``.

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

.. _pillar-jenkins-job_cleaner-days_to_del:

jenkins:job_cleaner:days_to_del
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Days for job to be considered as old and delete by jobs cleanup script.

Default: ``15`` days.

.. _pillar-jenkins-job_cleaner-username:

jenkins:job_cleaner:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's username

.. _pillar-jenkins-job_cleaner-token:

jenkins:job_cleaner:token
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's API token. Visit ``/user/USERNAME/configure`` to
get this value.
