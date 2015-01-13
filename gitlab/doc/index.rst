..
   Author: Diep Pham <favadi@robotinfra.com>
   Maintainer: Diep Pham <favadi@robotinfra.com>

Gitlab
======

Open source software to collaborate on code:

* Git repository management, code reviews, issue tracking, activity feeds, wikis
  and continuous integration
* 25,000 users on one server or a highly available active/active cluster,
  LDAP/AD group sync and audit logging
* Community driven, 700+ contributors, inspect and modify the source, easy to
  integrate into your infrastructure

Homepage: https://about.gitlab.com

.. warning::

   There is a `known bug <https://github.com/unbit/uwsgi/issues/798>`_
   with GitLab and :doc:`/uwsgi/doc/index` that causes error when use
   git with https.  We disable https support for clone/push for that
   reason.

.. toctree::
    :glob:

    *
