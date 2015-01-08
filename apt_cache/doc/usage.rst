Usage
=====

More can be find at `Apt-Cacher NG Help`_ page.

Cached APT URL
--------------

Go to :ref:`glossary-Ubuntu` http://mirrors.ubuntu.com/mirrors.txt and pick a
local mirror for the physical location of the installed host.

Or run on the target host itself::

  wget -O - -q http://mirrors.ubuntu.com/mirrors.txt


The URL will be::

  deb http://{{ salt['pillar.get']('apt_cache:hostnames')[0] }}/{{ MIRROR }}/ubuntu {{ salt['grains.get'('oscodename') }} ...

Such as::

  deb http://apt.local/mirror-fpt-telecom.fpt.net/ubuntu precise main restricted universe multiverse


Salt common host
----------------

Set :ref:`pillar-apt-sources` to something like::

  apt:
    cache: False
    sources: |
      deb http://192.168.111.112:3142/mirror-fpt-telecom.fpt.net/ubuntu {{ salt['grains.get']('oscodename') }} main restricted universe multiverse
      deb http://192.168.111.112:3142/mirror-fpt-telecom.fpt.net/ubuntu {{ salt['grains.get']('oscodename') }}-updates main restricted universe multiverse

Non Salt-common managed host
----------------------------

Edit ``/etc/apt/sources.list`` and switch the :ref:`glossary-URL`.

.. _Apt-Cacher NG Help: https://www.unix-ag.uni-kl.de/~bloch/acng/html/