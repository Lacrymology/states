{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

fail2ban:
  service:
    - dead
    - enable: False
  process:
    - wait_for_dead
    - timeout: 60
    - name: "/usr/bin/fail2ban-server"
    - require:
      - service: fail2ban
  cmd:
    - run
    - name: rm -f $(cat /usr/local/fail2ban/install.log)
    - require:
      - process: fail2ban

{%- for dir in ('/etc', '/etc/init.d', '/etc/logrotate.d', '/usr/local', '/usr/share', '/usr/share/doc', '/var/log', '/var/run') %}
{{ dir }}/fail2ban:
  file:
    - absent
    - require:
      - cmd: fail2ban
{%- endfor %}
