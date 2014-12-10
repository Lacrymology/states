Usage
=====

.. TODO: FIX

Web UI
------

After installing, you can login to the :doc:`index` UI by using the account that
is defined in :doc:`pillar` key ``shinken:users``.

Click ``All`` section to see all notifications on :doc:`index` that include:

- ``CRITICAL``
- ``WARNING``
- ``UNKNOWN``
- ``UP``
- ``OK``

Click ``IT problems`` to see notifications that only include something ralated
to errors.

With these error notifications that can be considered are ignored. Let
acknowledge by click ``Acknowledge`` at ``Actions`` section.

Refresh Service
~~~~~~~~~~~~~~~

Login to the Web UI in the URL specified in :doc:`/shinken/doc/pillar`, you will have an
overview of business impact.

then on the Web UI:

* click on the service
* choose ``Commands`` tab
* and ``Recheck now``

From the :doc:`/shinken/doc/index` Web UI, you can also go to :doc:`/graphite/doc/index` by clicking on the
``Shinken`` menu on the top-left.
