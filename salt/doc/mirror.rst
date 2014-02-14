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

How to build a mirror with debmirror
====================================

I wrote a simple macro at `lib.sls`. This macro must be called in the following
order::

  debmirror(arch,
            section,
            server,
            release,
            in_path,
            proto,
            out_path,
            **kwargs)

Whenever you want to create a local repository, all you have to do is create a `sls` file::

  {% set version = '0.17.5-1' %}

  {% from 'lib.sls' import debmirror with context %}

  {{ debmirror('i386,amd64', 'main,restricted,universe,multiverse', 'ppa.launchpad.net', 'precise', '/saltstack/salt/ubuntu', 'http', '/var/lib/salt_archive/mirror/salt/' ~ version, key_url='http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6', gnupghome='/home/mirrorkeyring') }}

Then run the following command from the Salt master::

  salt -t 600 minionid state.sls salt.archive.mirror

It will create the structure like below::

  /var/lib/salt_archive/mirror/salt/0.17.5-1
  ├── dists
  │   └── precise
  │       ├── main
  │       │   ├── binary-amd64
  │       │   └── binary-i386
  │       ├── Release
  │       └── Release.gpg
  ├── pool
  │   └── main
  │       ├── b
  │       │   └── botocore
  │       ├── libc
  │       │   └── libcloud
  │       ├── p
  │       │   ├── pytest
  │       │   └── pyzmq
  │       ├── s
  │       │   ├── salt
  │       │   ├── salt-api
  │       │   └── salt-cloud
  │       ├── t
  │       │   └── tox
  │       └── z
  │           └── zeromq3
  └── project
      └── trace
          └── localhost
  
  /var/lib/salt_archive/mirror/salt/0.17.5-1/pool/main/s
  ├── salt
  │   ├── salt-common_0.17.5-1precise_all.deb
  │   ├── salt-doc_0.17.5-1precise_all.deb
  │   ├── salt-master_0.17.5-1precise_all.deb
  │   ├── salt-minion_0.17.5-1precise_all.deb
  │   ├── salt-ssh_0.17.5-1precise_all.deb
  │   └── salt-syndic_0.17.5-1precise_all.deb
  ├── salt-api
  │   └── salt-api_0.8.3_all.deb
  └── salt-cloud
      ├── salt-cloud_0.8.9-1precise_all.deb
      └── salt-cloud-doc_0.8.9-1precise_all.deb
