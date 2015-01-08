Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/shinken/broker/doc/index` also run a web interface :doc:`/nginx/doc/index`
  :doc:`/nginx/doc/firewall`

:doc:`/shinken/doc/index` monitoring server includes the following :ref:`glossary-daemon`:

- :doc:`/shinken/arbiter/doc/index`
- :doc:`/shinken/broker/doc/index`
- :doc:`/shinken/poller/doc/index`
- :doc:`/shinken/reactionner/doc/index`
- :doc:`/shinken/receiver/doc/index`
- :doc:`/shinken/scheduler/doc/index`

:doc:`/shinken/arbiter/doc/index` need to access all other nodes that run :doc:`/shinken/doc/index` :ref:`glossary-daemon` on the following
ports:

- :ref:`glossary-TCP` ``7768``: Shinken :doc:`/shinken/scheduler/doc/index`
- :ref:`glossary-TCP` ``7769``: Shinken :doc:`/shinken/reactionner/doc/index`
- :ref:`glossary-TCP` ``7770``: Shinken :doc:`/shinken/arbiter/doc/index`
- :ref:`glossary-TCP` ``7771``: Shinken :doc:`/shinken/poller/doc/index`
- :ref:`glossary-TCP` ``7773```: Shinken :doc:`/shinken/broker/doc/index`
- :ref:`glossary-TCP` ``7774``: Shinken :doc:`/shinken/receiver/doc/index`
- :ref:`glossary-TCP` ``5667``: NSCA Daemon (:doc:`/shinken/receiver/doc/index`)
