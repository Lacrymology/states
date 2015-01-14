{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('fail2ban') }}

fail2ban_installed_files:
  cmd:
    - run
    - name: rm -f $(cat /usr/local/fail2ban/install.log)
    - require:
      - service: fail2ban

{%- for dir in ('/etc', '/etc/logrotate.d', '/usr/local', '/usr/share', '/usr/share/doc', '/var/log', '/var/run') %}
{{ dir }}/fail2ban:
  file:
    - absent
    - require:
      - cmd: fail2ban_installed_files
{%- endfor %}
