Usage
=====

Based from :doc:`pillar` values, log into URL one of the :ref:`pillar-sentry-hostnames`
(if DNS had been configured properly) using username
:ref:`pillar-sentry-initial_admin_user-username` and password
:ref:`pillar-sentry-initial_admin_user-password`.

.. TODO: FIX USAGE DOC

Create user
-----------

Default user can create account by click `Create a new account`. Then put `Email*`, `Password*`. And then click `Register`.

Create team
-----------

To create team. You need to login by admin account. Then click `Create a New Team`. Then put `Team Name*`, `Owner`. And then click `Create Team`.

Create project
--------------

After you already create team. You can create project. Only put `Project Name*`, `Platform*` and `Owner`. And then click `Save Changes.`

Delete group Manually
---------------------

Sometimes it take so much time to delete a group that it timeout
:doc:`/nginx/doc/index` and :doc:`/uwsgi/doc/index`. A hack for this is to note
the group ID in the URL, such as:
https://sentry.example.com/team/project/group/1234/ the id is ``1234``.

Then run::

  /usr/local/sentry/manage  shell
  In [1]: from sentry.models import Group
  In [2]: Group.objects.get(id=1234).delete()

And wait, it can take a long time for group with 100 000 and more alerts.
