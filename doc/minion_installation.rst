Salt-Minion Installation
========================

:authors: - Bruno Clermont

Copy the file ``salt/minion/bootstrap.sh`` to target and run it with it's ID
followed by the IP or hostname of the Salt master::

  ./bootstrap.sh mysuperminion 192.168.1.2

Then on salt master::

  salt-key -a mysuperminion

Test your minion connectivity::

  salt mysuperminion test.ping

Before running state.highstate, synchronize it::

  salt mysuperminion saltutil.sync_all

