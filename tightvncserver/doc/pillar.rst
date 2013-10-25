Pillar
======

Mandatory
---------

Example::

  tightvncserver:
    password: vncpassword

tightvncserver:password
~~~~~~~~~~~~~~~~~~~~~~~

Password to login server ia VNC viewer.

Optional
--------

Example::

  tightvncserver:
    wm: fluxbox
    resolution: 1024x768
    user: vnc
    user_passwd: vnc
    sudo: False
    password: 12345678
    display: 1

tightvncserver:wm
~~~~~~~~~~~~~~~~~

Name of window manager, That run by VNC server.
Currently we only support fluxbox.

Default: ``fluxbox``.

tightvncserver:user
~~~~~~~~~~~~~~~~~~~

Name of user who run VNC service.

Default: ``vnc``.

tightvncserver:user_passwd
~~~~~~~~~~~~~~~~~~~~~~~~~~

Password of VNC user.

Default: random.

tightvncserver:sudo
~~~~~~~~~~~~~~~~~~~

VNC user is a sudoer?

Default: ``False``.

tightvncserver:resolution
~~~~~~~~~~~~~~~~~~~~~~~~~

Screen resolution that show in VNC viewer when access to VNC server.

Default: ``1024x768``.

tightvncserver:display
~~~~~~~~~~~~~~~~~~~~~~

Which X display to use.

Default: ``1``.
