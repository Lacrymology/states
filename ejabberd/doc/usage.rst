Usage
=====

After the installation is finished, you can login and modify all the
settings in :doc:`/ejabberd/doc/index` web administrator interface at
`http(s)://im.example.com/admin` (as specify in pillar key
:ref:`pillar-ejabberd-hostnames`).

Client Configuration
--------------------

You can use an XMPP client on your operating system (such as `Pidgin
<https://www.pidgin.im/>`_, `Empathy
<https://wiki.gnome.org/action/show/Apps/Empathy?action=show&redirect=Empathy>`_
...) to communicate with server with below infomations::

  Username: user1
  Domain: im.example.com
  Server: im.example.com
  Port: 5222

Then, add your friend and start chatting.

Set up Pidgin for XMPP
~~~~~~~~~~~~~~~~~~~~~~

This is XMPP setup intruction for Pigin:

#. Open Pidgin.
#. Click the Accounts menu and click Manage Accounts.
#. Click Add.
#. In the Protocol field, select XMPP.
#. In the Username field, enter your username. For example, ``user1``.
#. In the Domain field, enter your domain, such as ``im.example.com``.
#. In the Password field, enter the password used to log in to SmarterMail.
#. Select the Remember password checkbox if you need.
#. Click the Advanced tab.
#. In the Connection Security field, select Use encryption if available.
#. In the Connect Server field, enter XMPP server address,
   such as ``im.example.com``.
#. Click Add.

And wait for connection.
