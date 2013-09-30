Pillar
======

Mandatory
---------

Optional
--------
tightvncserver:
  wm: fluxbox
  resolution: 1024x768
  user: vnc
  user_passwd: vnc
  sudo: False
  password: 12345678


tightvncserver:wm
~~~~~~~~~~~~~~~~~

Name of window manager, That run by VNC server
Currently we only support fluxbox

tightvncserver:user
~~~~~~~~~~~~~~~~~~~

Name of user who run VNC service


tightvncserver:user_passwd
~~~~~~~~~~~~~~~~~~~~~~~~~~

Password of VNC user


tightvncserver:password
~~~~~~~~~~~~~~~~~~~~~~~

Password to login via VNC viewer

tightvncserver:sudo
~~~~~~~~~~~~~~~~~~~

VNC user is a sudoer?

tightvncserver:resolution
~~~~~~~~~~~~~~~~~~~~~~~~~

Screen resolution when VNC run
