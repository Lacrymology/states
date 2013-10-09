Pillar
======

Mandatory
---------

Example::

  apt:
    sources: |
      deb http://mirror.anl.gov/pub/ubuntu/ {{ grains['oscodename'] }} main
      restricted universe multiverse
      deb http://security.ubuntu.com/ubuntu {{ grains['oscodename'] }}-security
      main restricted universe multiverse
      deb http://archive.canonical.com/ubuntu {{ grains['oscodename'] }} partner

apt:sources
~~~~~~~~~~~

Content of sources.list file as multiline pillar.

Optional
--------

proxy_server
~~~~~~~~~~~~

If True, the specific HTTP proxy server (without authentication) is used to
download .deb and reach APT server.

Default: ``False``.

