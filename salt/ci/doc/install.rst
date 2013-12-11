Continuous Integration
======================

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

Take a look at the `intro.rst` to have an overview.

Installation
------------

Follow the instruction in the `salt/ci/doc/pillar.rst` and
`jenkins/doc/pillar.rst` to create the pillar, for e.g::

  include:
    - common
  
  roles:
    - ci
  
  jenkins:
    hostnames:
      - q-ci.robotinfra.com
  
  salt_archive:
    source: rsync://q-salt.robotinfra.com/archive/

Don't forget to update the `top.sls` file to include this role::

  base:
    q-configs:
      - configs
      - cloud
      - ci

Run the following command to install Jenkins on the same machine that is running Salt master::

  salt -t 6000 q-configs state.sls salt.ci -v

If there is no "Failed", access to the web interface and follow the instruction in the `jenkins.rst` to configure and run a testing job.
