Usage
=====

.. _ejabberd-login_admin:

Login administrative interface
------------------------------

After the installation is finished, you can change all settings in
:doc:`index` web administrator interface by login in one
of the :ref:`pillar-ejabberd-hostnames` in ``/admin`` path.  Use the
credential defined in :ref:`pillar-ejabberd-admins`.

.. warning::

  For security reason, it's suggested to change password after
  installation.

.. _ejabberd-usage-user_creation:

User creation
-------------

#. :ref:`ejabberd-login_admin`
#. Go in ``Virtual Hosts``  (``/admin/vhosts/``), pick one.
#. Go in ``Users`` sub-section (``/admin/server/{{ vhost }}/users/``).
#. Fill ``User`` and ``Password``, save.

Client Configuration
--------------------

You can use an :ref:`glossary-xmpp` client on your operating system (such as
`Pidgin <https://www.pidgin.im/>`_, `Empathy
<https://wiki.gnome.org/action/show/Apps/Empathy?action=show&redirect=Empathy>`_
...) to communicate with server with below infomations::

  Username: user1
  Domain: im.example.com
  Server: im.example.com
  Port: 5222

Then, add your friend and start chatting.

Set up Pidgin for XMPP
~~~~~~~~~~~~~~~~~~~~~~

This is :ref:`glossary-xmpp` setup intruction for Pigin:

#. Open Pidgin.
#. Click the ``Accounts`` menu and click ``Manage Accounts``.
#. Click ``Add``.
#. In the ``Protocol`` field, select ``:ref:`glossary-xmpp```.
#. In the ``Username`` field, enter your username. For example, ``user1``.
#. In the ``Domain`` field, enter your domain, such as ``im.example.com``.
#. In the ``Password`` field, enter the password.
#. Select the ``Remember password`` checkbox if you need.
#. Click the ``Advanced`` tab.
#. In the ``Connection Security`` field, select ``Use encryption if
   available``.
#. In the ``Connect Server`` field, enter :ref:`glossary-xmpp` server address,
   such as ``im.example.com``.
#. Click ``Add``.

And wait for connection.
