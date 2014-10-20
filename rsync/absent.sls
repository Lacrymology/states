{#-
Copyright (c) 2013, Hung Nguyen Viet
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
Author: Hung Nguyen Viet hvnsweeting@gmail.com
Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
rsync:
  pkg:
    - purged
    - require:
      - service: rsync
  file:
    - absent
    - name: /etc/init/rsync.conf
    - require:
      - pkg: rsync
      - service: rsync
  service:
    - dead

/etc/rsyncd.conf:
  file:
    - absent
    - require:
      - pkg: rsync
      - service: rsync

rsync-upstart-log:
  cmd:
    - run
    - name: find /var/log/upstart/ -maxdepth 1 -type f -name 'rsync.log*' -delete
    - require:
      - pkg: rsync
      - service: rsync

/etc/rsyslog.d/rsync-upstart.conf:
  file:
    - absent

/etc/xinetd.d/rsync:
  file:
    - absent
    - require:
      - pkg: rsync