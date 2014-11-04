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

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- if salt['pillar.get']('aws:s3', False) %}

include:
  - backup.client.s3
  - backup.client.s3.nrpe
  - backup.dumb

test_s3lite:
  cmd:
    - run
    - cwd: /usr/local/s3lite/bin/
    - name: /usr/local/s3lite/bin/s3lite s3lite s3://{{ pillar['aws']['s3']['bucket'] }}/{{ pillar['aws']['s3']['path'].strip('/') }}
    - require:
      - sls: backup.client.s3
      - sls: backup.client.s3.nrpe
  file:
    - serialize
    - name: /etc/nagios/nsca.d/backup.client.s3lite.yml
    - require:
      - file: /etc/nagios/nsca.d
    - dataset:
        test_s3lite:
          command: /usr/lib/nagios/plugins/check_backup_s3lite.py --formula=backup.client.s3lite --check=test_s3lite
          arguments:
            path: s3lite
            bucket: s3://{{ pillar['aws']['s3']['bucket'] }}/{{ pillar['aws']['s3']['path'].strip('/') }}
  monitoring:
    - run_check
    - name: test_s3lite
    - require:
      - cmd: test_s3lite
      - file: test_s3lite

cleanup_s3lite:
  cmd:
    - run
    - name: s3cmd ls s3://{{ pillar['aws']['s3']['bucket'] }}/{{ pillar['aws']['s3']['path'].strip('/') }}/s3lite* | awk '{ print $4 }' | xargs s3cmd del
    - require:
      - pkg: s3cmd
      - monitoring: test_s3lite
  file:
    - absent
    - name: /etc/nagios/nsca.d/backup.client.s3lite.yml
    - require:
      - monitoring: test_s3lite

test_s3cmd:
  cmd:
    - run
    - name: /usr/local/bin/backup-store `/usr/local/bin/create_dumb`
    - require:
      - file: /usr/local/bin/backup-store
      - file: /usr/local/bin/create_dumb
      - file: /etc/nagios/backup.yml
  file:
    - serialize
    - name: /etc/nagios/nsca.d/backup.client.s3cmd.yml
    - require:
      - file: /etc/nagios/nsca.d
    - dataset:
        test_s3cmd:
          command: /usr/lib/nagios/plugins/check_backup.py --formula=backup.client.s3cmd --check=test_s3cmd
          arguments:
            facility: test_s3cmd
  monitoring:
    - run_check
    - name: test_s3cmd
    - require:
      - cmd: test_s3cmd
      - file: test_s3cmd
      - cmd: cleanup_s3lite

cleanup_s3cmd:
  cmd:
    - run
    - name: s3cmd ls s3://{{ pillar['aws']['s3']['bucket'] }}/{{ pillar['aws']['s3']['path'].strip('/') }}/backup-client-test* | awk '{ print $4 }' | xargs s3cmd del
    - require:
      - pkg: s3cmd
      - monitoring: test_s3cmd
  file:
    - absent
    - name: /etc/nagios/nsca.d/backup.client.s3cmd.yml
    - require:
      - monitoring: test_s3cmd

test:
  monitoring:
    - run_all_checks
    - order: last
    - exclude:
      - test_s3lite
      - test_s3cmd

{%- else %}

test_s3lite_run_sample_backup:
  cmd:
    - run
    - name: echo 'No S3 credential for testing backup'

{%- endif %}
