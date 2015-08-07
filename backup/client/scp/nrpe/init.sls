{#- Usage of this is governed by a license that can be found in doc/license.rst -#}


include:
  - backup.client.base.nrpe
  - bash.nrpe
  - nrpe
  - ssh.client.nrpe
{%- set address = salt['pillar.get']('backup_server:address') %}
{%- if address in grains['ipv4'] or
       address in ('localhost', grains['host']) %}
  {#- If backup_server address set to localhost (mainly in CI testing), install backup.server first #}
  - backup.server.nrpe
{%- endif %}

/etc/nagios/backup.yml:
  file:
    - managed
    - template: jinja
    - source: salt://backup/client/scp/nrpe/config.jinja2
    - user: root
    - group: nagios
    - mode: 440
    - require:
      - module: nrpe-virtualenv

check_backup.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_backup.py
    - source: salt://backup/client/scp/nrpe/check.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - file: /etc/nagios/backup.yml
      - file: /usr/local/nagios/lib/python2.7/check_backup_base.py
      - module: backup_client_nrpe-requirements
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

/usr/local/nagios/backup.client.scp.nrpe-requirements.txt:
  file:
    - absent

backup_client_nrpe-requirements:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/backup.client.scp.nrpe
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
    - requirements: {{ opts['cachedir'] }}/pip/backup.client.scp.nrpe
    - require:
      - virtualenv: nrpe-virtualenv
    - watch:
      - file: backup_client_nrpe-requirements
