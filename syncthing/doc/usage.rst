Usage
=====

When :ref:`pillar-syncthing-hostnames` is undefined, to connect to admin web
interface, create a SSH tunnel with following command.

.. code-block:: bash

   ssh -L 18384:localhost:8384 username@example_server.com

And connect to ``http://localhost:18384`` using browser.
