.. Copyright (c) 2013, Lam Dang Tung
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Lam Dang Tung nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`

.. warning::

  Make sure that :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`
  key ``ssh:server:extra_configs`` allow the user ``gitlab`` in.

Mandatory
---------

Example::

  gitlab:
    hostnames:
      - gitlab.axmple.com
    admin:
      password: mypass

gitlab:hostnames
~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

gitlab:admin:password
~~~~~~~~~~~~~~~~~~~~~

Password for :doc:`/gitlab/doc/index` Administrator account.

Optional
--------

Example::

  gitlab:
    smtp:
      enabled: False
    workers: 2
    idle: 300
    cheaper: 1
    timeout: 60
    ssl: example_com
    port: 80
    email_from: support@exmple.com
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
    ssh_port: 22
    max_size: 5242880
    commit_timeout: 10
    ldap:
      enabled: False

gitlab:commit_timeout
~~~~~~~~~~~~~~~~~~~~~

Git timeout to read a commit, in seconds

Default: ``10``.

gitlab:max_size
~~~~~~~~~~~~~~~

Max size of a git object (e.g. a commit), in bytes.
This value can be increased if you have very large commits

Default: ``5242880``. It's 5 megabytes.

gitlab:ssh_port
~~~~~~~~~~~~~~~

Specify your ssh port.

Default: ``22``.

gitlab:default_projects_features:visibility_level
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set default visibility level when create new project.
Can be "private" | "internal" | "public"

Default: ``private``.

gitlab:default_projects_features:snippets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable snippets feature as default option for new project.

Default: ``False``.

gitlab:default_projects_features:wall
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable wall feature as default option for new project.

Default: ``False``.

gitlab:default_projects_features:wiki
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable wiki feature as default option for new project.

Default: ``True``.

gitlab:default_projects_features:merge_requests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable merge requests feature as default option for new project.

Default: ``True``.

gitlab:default_projects_features:issues
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable issue feature as default option for new project.

Default: ``True``.

gitlab:issue_closing_pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Automatic issue closing.
If a commit message matches this regular expression, all issues referenced from
the matched text will be closed. This happens when the commit is pushed or
merged into the default branch of a project.

Default: ``([Cc]lose[sd]|[Ff]ixe[sd]) +#\d+``.

gitlab:signup_enabled
~~~~~~~~~~~~~~~~~~~~~

User can sign up.
Account passwords are not sent via the email if signup is enabled.

Default: ``False``.

gitlab:signin_enabled
~~~~~~~~~~~~~~~~~~~~~
The standard login can be disabled to force login via LDAP

Default: ``False``.

gitlab:default_can_create_group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

User can create group.

Default: ``True``.

gitlab:username_changing_enabled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

User can change username/namespace.

Default: ``True``.

gitlab:admin:projects_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Max projects that administrator can be created.

Default: ``1000``.

gitlab:email_from
~~~~~~~~~~~~~~~~~

Email address used in the "From" field in mails sent by GitLab

Default: empty list (``[]``).

gitlab:default_projects_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Default maximum number of projects a single user can create.

Default: ``10``.

.. gitlab:port
.. Port listen on web
.. Default: ``80``. You should not change it.

gitlab:ssl
~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

gitlab:ssl_redirect
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

gitlab::(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc

gitlab:ldap:enabled
~~~~~~~~~~~~~~~~~~~

If it's true, you must define the following :doc:`/openldap/doc/index`
:doc:`/openldap/doc/pillar` keys:

- ``gitlab:ldap:uid`` to ``sAMAccountName``
- ``gitlab:ldap:allow_username_or_email_login``: ``True``

gitlab:smtp
~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc
