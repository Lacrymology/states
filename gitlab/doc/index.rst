..
   Author: Diep Pham <favadi@robotinfra.com>
   Maintainer: Diep Pham <favadi@robotinfra.com>

Gitlab
======

Introduction
------------

GitLab is a web-based Git repository manager with wiki and issue tracking
features. GitLab is similar to :ref:`glossary-github`, but GitLab allows developers to store the
code on their own servers rather than servers operated by :ref:`glossary-github`.

.. http://en.wikipedia.org/wiki/GitLab

Open source software to collaborate on code:

* Git repository management, code reviews, issue tracking, activity feeds, wikis
  and continuous integration
* 25,000 users on one server or a highly available active/active cluster,
  :doc:`/openldap/doc/index`/AD group sync and audit logging
* Community driven, 700+ contributors, inspect and modify the source, easy to
  integrate into your infrastructure

.. https://about.gitlab.com

.. warning::

   There is a `known bug <https://github.com/unbit/uwsgi/issues/798>`_
   with GitLab and :doc:`/uwsgi/doc/index` that causes error when use
   git with https.  We disable https support for clone/push for that
   reason.

Links
-----

* `Gitlab Homepage <https://about.gitlab.com>`_
* `Wikipedia <http://en.wikipedia.org/wiki/GitLab>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/git/doc/index`
* :doc:`/nginx/doc/index`
* :doc:`/postgresql/doc/index`
* :doc:`/python/doc/index`
* :doc:`/redis/doc/index`
* :doc:`/ruby/doc/index`
* :doc:`/ssh/doc/index`
* :doc:`/ssl/doc/index`
* :doc:`/uwsgi/doc/index`
* :doc:`/nginx/doc/index`

Content
-------

.. toctree::
    :glob:

    *
