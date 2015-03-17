..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Salt Master
===========

Introduction
------------

.. TODO: INTRODUCTION TO SALT MASTER

Consider seriously adding a :doc:`/salt/archive/doc/index`
to the role of the Salt Master. That will speed up deployment of hosts and make
them more resilient on third-party failure.

In case there is no available git server already, adding
:doc:`/git/server/doc/index` to the role can be an option.
See :doc:`git` for details.

If you need to perform remote call using
`REST <http://en.wikipedia.org/wiki/Representational_state_transfer>`_
consider add ``salt.api`` to the list of included formulas in the role.
Check :doc:`/salt/api/doc/index` for more details.

Time synchronization is also important between all hosts. The
Salt Master is a good candidate of source time using
:doc:`/ntp/doc/index` protocols. Please consider add ``ntp``
and turn on it's server feature, details in :doc:`/ntp/doc/index`.

.. toctree::
    :glob:

    *
