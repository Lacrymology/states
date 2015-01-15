..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Bruno Clermont <bruno@robotinfra.com>

Custom pillar modules
=====================

Why? ``_pillars/``?
-------------------

Because we needed custom
`ext_pillar <http://docs.saltstack.com/en/latest/topics/development/external_pillars.html>`_
, but it need to be in a specific place in the Python path:

https://github.com/saltstack/salt/issues/3949

Until this is fixed, they will be here.
