{#-
Copyright (c) 2014, Hung Nguyen Viet
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

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>
#}

include:
  - virtualenv.nrpe
  - backup.client.s3.nrpe

/etc/nagios/backup_s3lite_sync.conf:
  file:
    - managed
    - template: jinja
    - source: salt://backup/client/s3lite/nrpe/check_config.jinja2
    - user: nagios
    - group: nagios
    - mode: 440
    - require:
      - pkg: nagios-nrpe-server

/usr/lib/nagios/plugins/check_s3lite_backup.py:
  file:
    - managed
    - source: salt://backup/client/s3lite/nrpe/check_s3_sync.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - file: /etc/nagios/backup_s3lite_sync.conf
      - pkg: nagios-nrpe-server
      - module: backup_client_nrpe-requirements
