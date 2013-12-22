DjangoPyPI 2
============

:Copyrights: Copyright (c) 2013, Quan Tong Anh

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Quan Tong Anh

DjangoPyPI is a Django application that provides a re-implementation of the
Python Package Index. Using Twitter Bootstrap for UI, forked from the original
DjangoPyPi project, DjangoPyPi2 provides an easy to use and manage interface.

Pillar
------

Follow the steps in the file `doc/pillar.rst` to create the pillar data for DjangoPyPI
2::

  djangopypi2:
    hostnames:
      - q-pip.robotinfra.com
    db:
      name: djangopypi2
      username: djangopypi2
      host: 127.0.0.1
      password: SqimoWkV
    django_key: 2ItjTsMu
    initial_admin_user:
      email: tonganhquan.net@gmail.com
      username: admin
      password: oy3BGACH

Push it to the `salt-pillars` repository and verify by running::

  salt q-pip pillar.items

Installation
------------

Run the following command on the Salt master::

  salt q-pip state.sls djangopypi2 -v

Have a look at the log file on the minion, if you see something like this::

  Executing command '/usr/local/djangopypi2/bin/django-admin.py loaddata
  --settings=djangopypi2.website.settings --initial' in directory '/root'
  output: Usage: /usr/local/djangopypi2/bin/django-admin.py loaddata [options]
  fixture [fixture ...]
  /usr/local/djangopypi2/bin/django-admin.py: error: no such option: --initial

it means that the module `djangomod.py` is parsing the options incorrectly.

Do the following steps as a workaround:

- copy the above module to the folder `_modules`
- remove the double dash before the options when calling `loaddata`::

  49,52c49
  <         if command == "loaddata":
  <             cmd = '{0} {1}'.format(cmd, arg)
  <         else:
  <             cmd = '{0} --{1}'.format(cmd, arg)
  ---
  >         cmd = '{0} --{1}'.format(cmd, arg)

- sync to the minion by executing::

  salt q-pip saltutil.sync_modules

Usage
-----

Surfing to `http://q-pip.robotinfra.com` and follow the steps in the file
`usage.rst` to upload the package.
