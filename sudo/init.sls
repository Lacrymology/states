{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set sentry_dsn = salt['pillar.get']('sentry_dsn', False) %}

include:
  - apt
  - hostname
{%- if sentry_dsn %}
  - raven.mail
{%- else %}
  - ssmtp
{%- endif %}

sudo:
  file:
    - managed
    - name: /etc/sudoers
    - source: salt://sudo/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: sudo
{%- if sentry_dsn %}
      - file: /usr/bin/ravenmail
{%- else %}
      - pkg: ssmtp
{%- endif %}
  pkg:
    - installed
    - require:
      - cmd: apt_sources
