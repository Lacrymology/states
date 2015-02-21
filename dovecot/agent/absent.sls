{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

dovecot-agent:
  user:
    - absent
  file:
    - absent
    - name: /home/dovecot-agent
    - require:
      - user: dovecot-agent
