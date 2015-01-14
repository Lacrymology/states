{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('postfix_stats') }}

postfix_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/PostfixCollector.conf

postfix_diamond_queue_length:
  file:
    - absent
    - name: /usr/local/diamond/share/diamond/user_scripts/postfix_queue_length.sh

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip_absent with context %}
{{ fail2ban_count_ip_absent('postfix') }}

/etc/rsyslog.d/postfix_stats.conf:
  file:
    - absent

/usr/local/diamond/bin/postfix_rsyslog.py:
  file:
    - absent

{{ opts['cachedir'] }}/pip/postfix.diamond:
  file:
    - absent
