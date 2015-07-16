{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('fail2ban') }}

extend:
  fail2ban:
    process:
      - wait_for_dead
      - timeout: 60
      - name: "/usr/bin/fail2ban-server"
      - require:
        - service: fail2ban
      - require_in:
        - file: fail2ban
        - file: /etc/rsyslog.d/fail2ban-upstart.conf
        - file: fail2ban-log
    cmd:
      - run
      - name: rm -f $(cat /usr/local/fail2ban/install.log)
      - require:
        - process: fail2ban

{%- for dir in ('/etc', '/etc/logrotate.d', '/usr/local', '/usr/share', '/usr/share/doc', '/var/log', '/var/run') %}
{{ dir }}/fail2ban:
  file:
    - absent
    - require:
      - cmd: fail2ban
{%- endfor %}
