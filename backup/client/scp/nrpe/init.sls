{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>
-#}

include:
  - backup.client.base
  - bash.nrpe
  - nrpe
  - ssh.client.nrpe
{%- if pillar['backup_server']['address'] in grains['ipv4'] or
       pillar['backup_server']['address'] in ('localhost', grains['host']) %}
  {#- If backup_server address set to localhost (mainly in CI testing), install backup.server first #}
  - backup.server.nrpe
{%- endif %}

{%- for keyname in salt['pillar.get']('ssh:keys', {}) %}
{%- set user = pillar['ssh']['keys'][keyname]['user'] %}
/etc/ssh/keys/{{ user }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700
    - makedirs: True
    - require:
      - pkg: openssh-client

/etc/ssh/keys/{{ user }}/{{ keyname }}:
  file:
    - managed
    - contents: |
        {{ pillar['ssh']['keys'][keyname]['contents'] | indent(8) }}
    - user: {{ user }}
    - group: {{ user }}
    - mode: 400
    - require:
      - file: /etc/ssh/keys/{{ user }}

openssh-client-identity-file:
  file:
    - append
    - name: /etc/ssh/ssh_config
    - text: |

        Host {{ keyname }} {% for extra_host in salt['pillar.get']('ssh:keys:' + keyname + ':extra_hosts', {}) %}{{ extra_host }}{% if not loop.last %} {% endif %}{% endfor %}
            IdentityFile /etc/ssh/keys/{{ user }}/{{ keyname }}
    - require:
      - file: /etc/ssh/keys/{{ user }}/{{ keyname }}
      - pkg: openssh-client
{%- endfor %}

/etc/nagios/backup.conf:
  file:
    - managed
    - template: jinja
    - source: salt://backup/client/scp/nrpe/config.jinja2
    - user: nagios
    - group: nagios
    - mode: 440
    - require:
      - pkg: nagios-nrpe-server

check_backup.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_backup.py
    - source: salt://backup/client/scp/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - file: /etc/nagios/backup.conf
      - file: /usr/local/nagios/lib/python2.7/check_backup_base.py
      - module: backup_client_nrpe-requirements

backup_client_nrpe-requirements:
  file:
    - managed
    - name: /usr/local/nagios/backup.client.scp.nrpe-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/client/scp/nrpe/requirements.jinja2
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/backup.client.scp.nrpe-requirements.txt
    - require:
      - virtualenv: nrpe-virtualenv
    - watch:
      - file: backup_client_nrpe-requirements
