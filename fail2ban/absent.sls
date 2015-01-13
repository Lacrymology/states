{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

fail2ban:
  service:
    - dead
    - enable: False
  pkg:
    - purged
    - require:
      - service: fail2ban
  file:
    - absent
    - name: /etc/fail2ban
    - require:
      - service: fail2ban

/etc/logrotate.d/fail2ban:
  file:
    - absent
    - require:
      - service: fail2ban
