Pillar
======

Mandatory 
---------

Optional 
--------

crontab_hour: 6
shinken_pollers:
  - 192.168.1.1

crontab_hour
~~~~~~~~~~~~

Each days cron launch a daily group of tasks, they are located in /etc/cron.daily/. 
This is the time of the day when they're executed.
Default: 6 hours in the morning, local time.

shinken_pollers
~~~~~~~~~~~~~~~

IP address of monitoring poller that check this server.
Default: not used.
