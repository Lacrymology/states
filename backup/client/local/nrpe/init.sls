{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - nrpe
  - backup.client.base.nrpe
  - backup.client.local
  - bash.nrpe

/etc/nagios/backup.yml:
  file:
    - managed
    - template: jinja
    - source: salt://backup/client/local/nrpe/config.jinja2
    - user: root
    - group: nagios
    - mode: 440
    - context:
        path: {{ salt["pillar.get"]("backup:local:path") }}
        subdir: {{ salt["pillar.get"]("backup:local:subdir", False)|default(grains["id"], boolean=True) }}
    - require:
      - module: nrpe-virtualenv

check_backup.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_backup.py
    - source: salt://backup/client/local/nrpe/check.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - file: /etc/nagios/backup.yml
      - file: /usr/local/nagios/lib/python2.7/check_backup_base.py
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive
