Infrastructure Installation
===========================

Introduction
------------

This document cover the steps to install an entire infrastructure including all
supports components.

Architecture
------------

Roles and pillars are required to deploy any hosts.
First look the :doc:`intro` and more advanced :doc:`usage` documentations for
details.

Then define the roles that correspond to business requirements and create their
formulas.

If you plan to perform any kind of monitoring and stats integration please look
at:

- :doc:`/nrpe/doc/index` :doc:`/nrpe/doc/pillar`
- :doc:`/diamond/doc/index` :doc:`/diamond/doc/pillar`

Dynamic DNS
~~~~~~~~~~~

Actually there is two salt state that allow to use salt formula to define
hostname:

- ``dnsimple`` for `DNSimple <https://dnsimple.com>`_
- ``route53`` for `Amazon Route53 <http://aws.amazon.com/route53/>`_

Feel free to use them in your roles to also automatically set DNS hostnames.

Pillars
-------

In :doc:`pillar` is listed all pillars keys that are required by many formulas.
Fill the roles list in pillars and all others.

Considerate that at this point, unless this is a new deployment plugged to an
existing support infrastructure (such as :doc:`monitoring`), all those required
pillars keys values don't exists yet.

Such as ``graylog2_address`` won't be usuable until salt-master deploy that host
but it can be defined before, using hostname or IPs.

Define all those pillar keys.

``sentry_dsn`` is the only key you can't define before the Sentry server had
been installed. Any value such as ``https://x:y@hostname/0`` can be used until
Sentry server is installed, team and project created.

Take extra care with ``files_archive`` if :doc:`/salt/archive/doc/index`
need to be bootstraped. Set the value of ``files_archive`` to same as
``salt_archive:source`` (:doc:`/salt/archive/doc/pillar`) until it's
deployed and then change it to any hostname in ``salt_archive:hostnames``.

Salt Master
-----------

As the entire infrastructure is installed through Salt, you first need to
install the initial salt master VM.

Define the role of that master host to include or not other formulas that might
improve performance of installed minions and also changed pillars keys you
need to define and the included formulas in the role.
Please look :doc:`/salt/master/doc/index` for details.

One of those role choice might be required to setup Git repositories first or
not, based on the architecture, see :doc:`/salt/master/doc/git` for details.

Once all git repositories consideration processed, the salt master can be
deployed :doc:`/salt/master/doc/install`.

Support Infrastructure
----------------------

Once that :doc:`/salt/master/doc/index` if fully functional,
the hosting/support infrastructure need to be deployed.

You can install each of them by :doc:`/salt/minion/doc/install`
:doc:`/salt/minion/doc/index` on those hosts.

And then on :doc:`/salt/master/doc/index` run::

  salt [minion-id] state.highstate

Here is a suggestion of sequence. This is a list of formulas
and not roles:

#. :doc:`/salt/archive/doc/index`. After that you should change
   ``files_archive`` in :doc:`/salt/archive/doc/pillar` for one of the
   ``salt_archive:hostnames``.
#. :doc:`/sentry/doc/index`
#. :doc:`/carbon/doc/index`
#. :doc:`/graphite/doc/index`
#. mail server related formulas
#. :doc:`/elasticsearch/doc/index`
#. :doc:`/graylog2/server/doc/index`
#. :doc:`/graylog2/web/doc/index`
#. :doc:`/shinken/doc/index`
#. :doc:`/backup/server/doc/index`

.. warning::

  If hostnames are used instead of IP address for some services.
  And if DNS is applied in roles.
  Those services might fail to start on first ``state.highstate``, as DNS
  entries might not had been created before they're started.

  To work around this, please use ``watch_in`` in DNS states to create them
  before they get installed.
