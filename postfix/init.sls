{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('postfix:ssl', False) -%}
{%- set spam_filter = salt['pillar.get']('postfix:spam_filter', False) %}
include:
{%- if spam_filter %}
{%- set check_virus = salt['pillar.get']('amavis:check_virus', True) %}
    {%- if check_virus %}
  - amavis.clamav
  - clamav.server
    {%- else %}
  - amavis
    {%- endif -%}
{%- endif %}
  - apt
  - mail
{%- if ssl %}
  - ssl
{%- endif %}
{%- if salt['pillar.get']('postfix:domains', [])|length > 0 %}
  - dovecot.agent

/var/mail/vhosts:
  file:
    - directory
    - user: dovecot-agent
    - require:
      - user: dovecot-agent
    - require_in:
      - service: postfix

/etc/postfix/vmailbox:
  file:
    - managed
    - source: salt://postfix/vmailbox.jinja2
    - template: jinja
    - mode: 400
    - user: postfix
    - group: postfix
    - require:
      - pkg: postfix

postmap /etc/postfix/vmailbox:
  cmd:
    - require:
      - pkg: postfix
      - file: /etc/postfix
    {% if salt['file.file_exists']('/etc/postfix/vmailbox.db') %}
    - wait
    - watch:
      - file: /etc/postfix/vmailbox
    {% else %}
      - file: /etc/postfix/vmailbox
    - run
    {% endif %}
{%- endif %}

apt-utils:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

postfix:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
      - pkg: apt-utils
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: postfix
  file:
    - managed
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - file_mode: 400
    - require:
      - pkg: postfix
      - file: /etc/postfix
  service:
    - running
    - order: 50
{%- if spam_filter %}
    - require:
      - service: amavis
    {%- if check_virus %}
      - service: clamav-daemon
    {%- endif -%}
{%- endif %}
    - watch:
      - pkg: postfix
      - user: postfix
      - file: /etc/postfix/master.cf
      - file: /etc/postfix
      - file: postfix
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}

postfix_header_checks:
  pkg:
    - installed
    - name: postfix-pcre
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
  file:
    - managed
    - name: /etc/postfix/smtp_header_checks
    - source: salt://postfix/smtp_header_checks.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - mode: 400
    - require:
      - pkg: postfix_header_checks
      - file: /etc/postfix
    - watch_in:
      - service: postfix

/etc/postfix:
  file:
    - directory
    - user: postfix
    - group: postfix
    - require:
      - pkg: postfix

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://postfix/master.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - mode: 400
    - require:
      - file: /etc/postfix

postfix_local_aliases:
  file:
    - managed
    - name: /etc/aliases
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - source: salt://postfix/aliases.jinja2
    - require:
      - pkg: postfix
  cmd:
    - wait
    - name: newaliases
    - watch:
      - file: postfix_local_aliases
{%- set virtual_aliases = salt['pillar.get']('postfix:virtual_aliases', False) %}

{%- if salt['pillar.get']('postfix:virtual_aliases', False) %}
{# contains alias for email forwarding #}
postfix_virtual_aliases:
  file:
    - managed
    - name: /etc/postfix/virtual
    - template: jinja
    - mode: 400
    - user: postfix
    - group: postfix
    - contents: |
        {{ salt['pillar.get']('postfix:virtual_aliases', False) | indent(8) }}
    - require:
      - pkg: postfix
  cmd:
    {%- if salt['file.file_exists']('/etc/postfix/virtual.db') %}
    - wait
    {%- else %}
    - run
    {%- endif %}
    - name: postmap /etc/postfix/virtual
    - watch:
      - file: postfix_virtual_aliases
{%- else %}
postfix_virtual_aliases:
  file:
    - absent
    - name: /etc/postfix/virtual
    - require:
      - pkg: postfix

/etc/postfix/virtual.db:
  file:
    - absent
    - require:
      - pkg: postfix
{%- endif %}
