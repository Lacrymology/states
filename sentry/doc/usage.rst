.. Copyright (c) 2013, Quan Tong Anh
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
.. Neither the name of Quan Tong Anh nor the names of its contributors may be used
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

Usage
=====

Based from :doc:`pillar` values, log into URL one of the ``sentry:hostnames``
(if DNS had been configured properly) using username
``sentry:initial_admin_user:username`` and password
``sentry:initial_admin_user:password``.

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
:doc:`nginx/doc/index` and :doc:`uwsgi/doc/index`. A hack for this is to note
the group ID in the URL, such as:
https://sentry.example.com/team/project/group/1234/ the id is ``1234``.

Then run::

  /usr/local/sentry/manage  shell
  In [1]: from sentry.models import Group
  In [2]: Group.objects.get(id=1234).delete()

And wait, it can take a long time for group with 100 000 and more alerts.
