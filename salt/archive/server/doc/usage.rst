File Archive server
===================

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

Installing the latest version often causes problems, so we build our own
mirrors of every files which are use to deploy states.

This also has some other advantages:

* Not depending on the pypi.python.org, github.com, ...
* Make the installation faster since everything is mirrored internally

Installation
------------

I am going to install on the same machine that is running Salt::

  salt myminion state.sls salt.archive -v

This only create the `salt_archive` user and the directory
(`/var/lib/salt_archive/`) to hold the data. 

To start syncing, run the following command::

  salt myminion state.sls salt.archive.server -v

After that, you can access to the `web <http://q-archive.robotinfra.com>`_ to see all the packages that was synced.

To add a "file age" check to the Nagios::

  salt myminion state.sls salt.archive.server.nrpe -v

An example when running from the command line::

  su - nagios -s /bin/sh -c '/usr/lib/nagios/plugins/check_file_age -w 3600 -c
  3600 /var/cache/salt/master/sync_timestamp.dat'
  FILE_AGE OK: /var/cache/salt/master/sync_timestamp.dat is 516 seconds old and
  0 bytes

Usage
-----

When you write a new state or pillar file, you should get the package from the file
archive server first (if it was defined in the pillar)::

  {%- if 'files_archive' in pillar %}
  {{ pillar['files_archive'] }}/pip/diamond-3.4.68.tar.gz
  {%- else %}
  -e
  git+git://github.com/BrightcoveOS/Diamond.git@2d1149fb9d419a3016f5fe8e0830fa0015fbda06#egg=diamond
  {%- endif %}
