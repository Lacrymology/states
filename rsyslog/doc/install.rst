rsyslog
=======

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

Centralized logging provides a number of benefits than logging on local
servers:

- searching through logs and analysis across multiple servers easier
- have a chance of finding something useful about what happened in the event of
  an instrusion or system failure
- log rotation mechanism can also be centralized

Installation
------------

Follow the steps in `doc/minion_installation.rst` to install `salt-minion`.

If you want to drop all noisy log (sudo open/close session), create a pillar
file as below::

  debug: False

from the Salt master, run the following command to install `rsyslog`::

  salt '*' state.sls rsyslog -v

then take a look at the last line in the configuration file, you will see
something like this::

  *.*;local7.none @q-logs.robotinfra.com:1514

it means that all the log will be forward via UDP to Graylog2 server, on port
1514.

Usage
-----

On the Graylog2 web interface, you can search all the logs from a specific host
by:

- click on the `messages` tab
- then `Quickfilter`
- select the `Host` and click on the `Run filter` button

If you want to get a notification on stream alarms, refer to the instructions
in the `graylog2/web/doc/usage.rst`.
