Usage
=====

Cached APT URL
--------------

Go to http://mirrors.ubuntu.com/mirrors.txt and pick a local mirror for the
physical location of the installed host.

Or run on the target host itself::

  wget -O - -q http://mirrors.ubuntu.com/mirrors.txt


The URL will be::

  deb http://{{ pillar['apt_cache:hostnames'] first value }}/{{ MIRROR }}/ubuntu {{ grains['oscodename'] }} ...

Such as::

  deb http://apt.local/mirror-fpt-telecom.fpt.net/ubuntu precise main restricted universe multiverse


Salt common host
----------------

.. TODO: link

Set pillar ``apt:sources`` like::

  apt:
    cache: False
    sources: |
      deb http://192.168.111.112:3142/mirror-fpt-telecom.fpt.net/ubuntu {{ grains['oscodename'] }} main restricted universe multiverse
      deb http://192.168.111.112:3142/mirror-fpt-telecom.fpt.net/ubuntu {{ grains['oscodename'] }}-updates main restricted universe multiverse


Non Salt common managed host
----------------------------

Edit ``/etc/apt/sources.list`` and switch the URLs.
