{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{% set ssl = salt['pillar.get']('dovecot:ssl', False) %}
include:
  - apt
  - dovecot.agent
  - postfix
  - rsyslog
{% if ssl %}
  - ssl
{% endif %}

{#- PID file owned by root, no need to manage #}

dovecot:
  pkg:
    - installed
    - pkgs:
      - dovecot-imapd
      - dovecot-pop3d
      - dovecot-ldap
      - dovecot-lmtpd
      - dovecot-managesieved
    - require:
      - cmd: apt_sources
      - pkg: postfix
  service:
    - running
    - order: 50
    - watch:
      - user: dovecot_user
      - user: dovecot-agent
      - file: /etc/dovecot/dovecot.conf
      - pkg: dovecot
      - file: /etc/dovecot/dovecot-ldap.conf.ext
      - file: /var/mail/vhosts/indexes
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}

{{ manage_upstart_log('dovecot') }}

{%- for user in ('dovecot', 'dovenull') %}
{{ user }}_user:
  user:
    - present
    - name: {{ user }}
    - shell: /bin/false
    - require:
      - pkg: dovecot
{%- endfor %}

{#- this setup uses only dovecot.conf config file, remove this dir for avoiding
    confusing #}
/etc/dovecot/conf.d:
  file:
    - absent
    - require:
      - pkg: dovecot
    - watch_in:
      - service: dovecot

/etc/dovecot/dovecot.conf:
  file:
    - managed
    - source: salt://dovecot/config.jinja2
    - template: jinja
    - mode: 444 {#- dovecot-agent needs to read it too, no sensitive data #}
    - user: root
    - group: dovecot
    - require:
      - pkg: dovecot
      - user: dovecot-agent

/etc/dovecot/dovecot-ldap.conf.ext:
  file:
    - managed
    - source: salt://dovecot/ldap.jinja2
    - mode: 440
    - template: jinja
    - user: root
    - group: dovecot
    - require:
      - pkg: dovecot

/var/mail/vhosts/indexes:
  file:
    - directory
    - user: dovecot-agent
    - makedirs: True
    - mode: 750
    - require:
      - user: dovecot-agent
