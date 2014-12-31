{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - hostname
  - rsyslog

ssmtp:
  pkg:
    - installed
    - require:
      - service: rsyslog
      - cmd: apt_sources
      - debconf: ssmtp
      - cmd: hostname
      - host: hostname
  debconf:
    - set
    - data:
        'ssmtp/mailhub': {'type': 'string', 'value': '{{ salt['pillar.get']('smtp:server') }}'}
{%- set mailname = salt['pillar.get']('mail:mailname') %}
        'ssmtp/hostname': {'type': 'string', 'value': '{{ mailname }}'}
        'ssmtp/root': {'type': 'string', 'value': '{{ salt['pillar.get']('smtp:root') }}'}
        'ssmtp/rewritedomain': {'type': 'string', 'value': ''}
        {# unused by the package itself, why? #}
        'ssmtp/overwriteconfig': {'type': 'boolean', 'value': False}
        'ssmtp/mailname': {'type': 'string', 'value': '{{ mailname }}'}
        'ssmtp/port': {'type': 'string', 'value': '{{ salt['pillar.get']('smtp:port') }}'}
        'ssmtp/fromoverride': {'type': 'boolean', 'value': False}
    - require:
      - pkg: apt_sources

bsd-mailx:
  pkg:
    - installed
    - require:
      - pkg: ssmtp
      - cmd: apt_sources

{% for template, config in (('config', 'ssmtp.conf'), ('revaliases', 'revaliases')) %}
/etc/ssmtp/{{ config }}:
  file:
    - managed
    - template: jinja
    - source: salt://ssmtp/{{ template }}.jinja2
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: bsd-mailx
      - pkg: ssmtp
{% endfor %}
