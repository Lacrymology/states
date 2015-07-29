Usage
=====

.. warning::

   Current version of :doc:`index` (7.4.1) has a bug that causes infinite
   redirect loop when a newly created user logins (see this `bug report
   <https://github.com/getsentry/sentry/issues/1463>`_). A user without an
   organization will be redirected to organization creating page, that always
   redirect to itself. To workaround this problem, login to :doc:`index`
   :doc:`/django/doc/index` admin page (append ``/admin`` to hostnames defined
   in :ref:`pillar-sentry-hostnames`) with
   :ref:`pillar-sentry-initial_admin_user-username` and
   :ref:`pillar-sentry-initial_admin_user-password`, create an organization with
   newly created user as owner.

Based from :doc:`pillar` values, log into :ref:`glossary-URL` one of the
:ref:`pillar-sentry-hostnames` (if :ref:`glossary-DNS` had been configured
properly) using username :ref:`pillar-sentry-initial_admin_user-username` and
password :ref:`pillar-sentry-initial_admin_user-password`.

.. TODO: FIX USAGE DOC

Create user
-----------

Default user can create account by click `Create a new account`. Then put
`Email*`, `Password*`. And then click `Register`.

Create team
-----------

To create team. You need to login by admin account. Then click `Create a New
Team`. Then put `Team Name*`, `Owner`. And then click `Create Team`.

Create project
--------------

After you already create team. You can create project. Only put `Project Name*`,
`Platform*` and `Owner`. And then click `Save Changes.`

Delete group Manually
---------------------

Sometimes it take so much time to delete a group that it timeout
:doc:`/nginx/doc/index` and :doc:`/uwsgi/doc/index`. A hack for this is to note
the group ID in the :ref:`glossary-URL`, such as:
https://sentry.example.com/team/project/group/1234/ the id is ``1234``.

Then run::

  /usr/local/sentry/manage  shell
  In [1]: from sentry.models import Group
  In [2]: Group.objects.get(id=1234).delete()

And wait, it can take a long time for group with 100 000 and more alerts.

XMPP Integration
----------------

``XMPP`` refer to the protocol of :doc:`/ejabberd/doc/index` and that allow
:doc:`index` to send chat notification to a conference room.

.. note::

  This plugin is configured **per project**, so different alerts can be sent to
  different conference room, these steps are required for each project.

#. Create :doc:`/ejabberd/doc/index` user for :doc:`index`, look in
   :ref:`ejabberd-usage-user_creation` for details.
#. Open in browser deployed :doc:`index` server (one of the
   :ref:`pillar-sentry-hostnames`).
#. Go to project ``Settings`` section
   (``/{{ team }}}/{{ project }}/settings/``).
#. In left sidebar menu, go into ``Manage Integrations``
   (``/{{ team }}}/{{ project }}/plugins/``).
#. Click on ``XMPP`` (``/{{ team }}}/{{ project }}/plugins/xmpp/``), no need to
   enable at this point.
#. Fill ``Jid`` of the created user, it need to contains the ``@{{ hostname }}``
   suffix, which is one of the hostname in :ref:`pillar-ejabberd-hostnames`.
#. Set ``Password`` , ``Nick`` that should be same username as in ``Jid``, the
   prefix before ``@``.
#. Fill ``Room`` and ``Room Password`` if required.
#. Save, perform same operations in all other projects.

.. warning::

  If the room is on invitation only, don't forget to invite it to the room.
