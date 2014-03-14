.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     * Redistributions of source code must retain the above copyright notice,
..       this list of conditions and the following disclaimer.
..     * Redistributions in binary form must reproduce the above copyright
..       notice, this list of conditions and the following disclaimer in the
..       documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

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
