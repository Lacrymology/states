Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`

.. warning::

   See :ref:`pillar-ssh-server-extra_configs`.

Mandatory
---------

Example::

  gitlab:
    hostnames:
      - gitlab.axmple.com
    admin:
      password: mypass

.. _pillar-gitlab-hostnames:

gitlab:hostnames
~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Example: ``__salt__['network.ip_addrs']('eth0')[0]``

.. _pillar-gitlab-admin-password:

.. warning::

   Consider destroy Administrator account after created an another
   admin.

gitlab:admin:password
~~~~~~~~~~~~~~~~~~~~~

Password for :doc:`/gitlab/doc/index` Administrator account.

Example: ``'123456789'``

.. note::

    If multiple ports are set and ``22`` is set in
    pillar key :ref:`pillar-ssh-server-ports` (see :doc:`/ssh/server/doc/index`)
    , use ``22`` as preferred value.
    Otherwise use the only value provided. In that case, user
    will need to specify their port in :doc:`/git/doc/index` config file.

Optional
--------

Example::

  gitlab:
    admin:
      email: admin@example.com
    workers: 2
    idle: 300
    cheaper: 1
    timeout: 60
    ssl: example_com
    email_from: support@example.com
    default_projects_limit: 10
    default_can_create_group: True
    username_changing_enabled: True
    signup_enabled: False
    signin_enabled: False
    restricted_visibility_levels: public
    issue_closing_pattern: ([Cc]lose[sd]|[Ff]ixe[sd]) +#\d+
    default_projects_features:
      issues: True
      merge_requests: True
      wiki: True
      wall: False
      snippets: False
      visibility_level: private
    max_size: 5242880
    commit_timeout: 10
    db:
      password: randompassword
    ldap:
      enabled: False

.. _gitlab-admin-email:

gitlab:admin:email
~~~~~~~~~~~~~~~~~~

The email address for the default Administrator account.
This can be used to login at the first time after installing.

Default: Use the value of :ref:`pillar-smtp-from` pillar key (``False``).

.. _pillar-gitlab-commit_timeout:

gitlab:commit_timeout
~~~~~~~~~~~~~~~~~~~~~

Git timeout to read a commit, in seconds

Default: abort if can't read a commit in ``30`` seconds.

.. _pillar-gitlab-max_size:

gitlab:max_size
~~~~~~~~~~~~~~~

Max size of a :doc:`/git/doc/index` object (e.g. a commit), in bytes.
This value can be increased if you have very large commits

Default: max size of a :doc:`/git/doc/index` object is 5 megabytes (``5242880``).

.. _pillar-gitlab-default_projects_features-visibility_level:

gitlab:default_projects_features:visibility_level
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set default `visibility level
<https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/public_access/public_access.md>`_
when create new project.  Can be:

 * private

 * internal

 * public

Default: ``private``.

.. _pillar-gitlab-default_projects_features-snippets:

gitlab:default_projects_features:snippets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable `snippets
<http://en.wikipedia.org/wiki/Snippet_%28programming%29>`_ feature as
default option for new project.

Default: disable snippers for new project (``False``).

.. _pillar-gitlab-default_projects_features-wiki:

gitlab:default_projects_features:wiki
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable `wiki
<https://github.com/gitlabhq/gitlabhq/blob/master/doc/workflow/project_features.md#wiki>`_
feature as default option for new project.

Default: enable wiki for new project (``True``).

.. _pillar-gitlab-default_projects_features-merge_requests:

gitlab:default_projects_features:merge_requests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable `merge requests
<https://github.com/gitlabhq/gitlabhq/blob/master/doc/workflow/project_features.md#merge-requests>`_
feature as default option for new project.

Default: enable merge requests for new project (``True``).

.. _pillar-gitlab-default_projects_features-issues:

gitlab:default_projects_features:issues
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable `issue
<https://github.com/gitlabhq/gitlabhq/blob/master/doc/workflow/project_features.md#issues>`_
feature as default option for new project.

Default: enable issues for new project (``True``).

.. _pillar-gitlab-issue_closing_pattern:

gitlab:issue_closing_pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Automatic issue closing.
If a commit message matches this regular expression, all issues referenced from
the matched text will be closed. This happens when the commit is pushed or
merged into the default branch of a project.

Default: ``([Cc]lose[sd]|[Ff]ixe[sd]) +#(\d+)``.

.. _pillar-gitlab-signup_enabled:

gitlab:signup_enabled
~~~~~~~~~~~~~~~~~~~~~

User can sign up.
Account passwords are not sent via the email if signup is enabled.

Default: disable signup (``False``).

.. _pillar-gitlab-signin_enabled:

gitlab:signin_enabled
~~~~~~~~~~~~~~~~~~~~~

The standard login can be disabled to force login via
:doc:`/openldap/doc/index`.

Default: The standard login form (username and password) will be shown on the
sign-in page (``True``).

.. _pillar-gitlab-default_can_create_group:

gitlab:default_can_create_group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

User can create group.

Default: allow user to creat group (``True``).

.. _pillar-gitlab-username_changing_enabled:

gitlab:username_changing_enabled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

User can change username/namespace.

Default: allow changing username/namespace (``True``).

.. _pillar-gitlab-default_projects_limit:

gitlab:default_projects_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Default maximum number of projects a single user can create.

Default: a user can create up to ``10`` projects.

.. _pillar-gitlab-ssl:

gitlab:ssl
~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-gitlab-ssl_redirect:

gitlab:ssl_redirect
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. |deployment| replace:: gitlab

.. include:: /uwsgi/doc/pillar.inc

.. _pillar-gitlab-ldap-enabled:

gitlab:ldap:enabled
~~~~~~~~~~~~~~~~~~~

If it's true, you must define the following :doc:`/openldap/doc/index`
:doc:`/openldap/doc/pillar` keys:

- :ref:`pillar-gitlab-ldap-uid` to `sAMAccountName`
- :ref:`pillar-gitlab-ldap-allow_username_or_email_login`- `True`

Default: disable :doc:`/openldap/doc/pillar` integration (``False``).

.. _pillar-gitlab-smtp:

gitlab:smtp
~~~~~~~~~~~

Override following SMTP settings.

Default: Unused (``False``)

.. include:: /mail/doc/smtp.inc

<<<<<<< HEAD
.. _pillar-gitlab-smtp-from:

gitlab:smtp:from
~~~~~~~~~~~~~~~~

The address that will appear in the "From:" field of the email sent by GitLab.

Default: Use the value of :ref:`pillar-smtp-from` (``False``).
=======
gitlab:smtp:from
~~~~~~~~~~~~~~~~

The address that will appear in the "From:" field of the email sending from
GitLab.

Default: Got value from :ref:`pillar-smtp-from` pillar key
(``salt['pillar.get']('smtp:from')``)
>>>>>>> erp2041: fix the remaining doc errors

.. _pillar-gitlab-db-password:

gitlab:db:password
~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

Conditional
-----------

.. _pillar-gitlab-ldap-uid:

gitlab:ldap:uid
~~~~~~~~~~~~~~~

:doc:`/openldap/doc/pillar` attribute name for the user name in the
login form.

Only use if :ref:`pillar-gitlab-ldap-enabled` is ``True``.

.. _pillar-gitlab-ldap-allow_username_or_email_login:

gitlab:ldap:allow_username_or_email_login
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Allow both username or email for login.

Only use if :ref:`pillar-gitlab-ldap-enabled` is ``True``.
