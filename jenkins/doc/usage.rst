Usage
=====

Follow the generic logic of pillar, apply formula and run checks, then perform
the followings.

Firstly, access one of the hostname that was specified at
:ref:`pillar-jenkins-hostnames` to access :doc:`/jenkins/doc/index` web UI.

Things you **should** do
------------------------

- Enable security in ``Configure Global Security`` then create an user.
  After that, switch to Matrix based security to prevent anonymous user to
  have read-only access to Jenkins.
- Install https://wiki.jenkins-ci.org/display/JENKINS/Timestamper and turn it
  on to all jobs.
- Set ``[a-zA-Z0-9\-]*`` as regular expression for job name. As job name are
  used to create VM hostname, this need to be a valid hostname.
- Do following steps in ``Manage Jenkins``.
- Set ``System Admin e-mail address``.
- Raise number of executor (``# of executors``) to large value such as ``20``.
- Set ``Jenkins URL`` to first value of ``jenkins:hostnames``.
- Configure SMTP to send email for build status change.

Useful plugins
--------------

.. note::

  all paths such as ``/log/all``, ``/configure`` are parts of URL after
  address of running :doc:`/jenkins/doc/index` server.

jabber
~~~~~~

`jabber <https://wiki.jenkins-ci.org/display/JENKINS/Jabber+Plugin>`_
enables Jenkins to send build notifications via Jabber, as well as let users
talk to Jenkins via a 'bot' to run commands, query build status etc...
Jabber is also know as XMPP, an Jabber server can be installed using formula
:doc:`/ejabberd/doc/index`. After installing this plugin,
:doc:`/jenkins/doc/index` needs to restart. For troubleshooting, look at
``/log/all``.

Configure Jabber through ``/configure``, check ``Enable Jabber Notification``
fill in Jabber ID and password, server, port should suffice to make it work.
Additional configuration (such as setup jabber bot, choosing room to join,
...) can be made after choosing ``Advanced...`` button in this section.
Then, in each CI build configuration, choose ``Add post-build action``, then
``Jabber notification``, fill in the Jabber ID whom should receive notify
for the build job status.

Written at ``Jenkins ver. 1.545`` and plugin ``jabber 1.25``.

Multiple SCMs
~~~~~~~~~~~~~

https://wiki.jenkins-ci.org/display/JENKINS/Multiple+SCMs+Plugin

Allow to checkout multiple repositories for a single project, such as more than
one :doc:`/git/server/doc/index`.

.. warning::

  This plugin don't work as expected on Jenkins slaves. You need to specify an
  ``Additional Behaviours``, choose ``Checkout to a sub directory`` and set
  ``Local subdirectory for repo``.