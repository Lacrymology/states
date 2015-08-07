{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.base.nrpe
  - bash.nrpe
  - nrpe

check_backup.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_backup.py
    - template: jinja
    - contents: |
        #!/usr/local/nagios/bin/python
        # # {{ salt['pillar.get']('message_do_not_modify') }}
        # A place-holder script always return 0
        # Which replaces check_backup.py in test mode
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
