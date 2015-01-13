{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - firewall
  - rsyslog

/etc/rsyslog.d/fail2ban.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        $RepeatedMsgReduction off
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

fail2ban:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/fail2ban/fail2ban.conf
    - source: salt://fail2ban/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: fail2ban
  service:
    - running
    - watch:
      - file: fail2ban

{%- for suffix in ('conf', 'local') %}
/etc/fail2ban/jail.{{ suffix }}:
  file:
    - managed
    - source: salt://fail2ban/jail_{{ suffix }}.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: fail2ban
    - watch_in:
      - service: fail2ban
{%- endfor %}

{%- call manage_pid('/var/run/fail2ban/fail2ban.pid', 'root', 'root', 'fail2ban', 600) %}
- pkg: fail2ban
{%- endcall %}
