{#
 Install SSMTP a simple interface to send mail to remote SMTP server
 #}
include:
  - apt
  - hostname
  - gsyslog

ssmtp:
  pkg:
    - installed
    - require:
      - service: gsyslog
      - cmd: apt_sources
      - debconf: ssmtp
      - cmd: hostname
      - host: hostname
  debconf:
    - set
    - data:
        'ssmtp/mailhub': {'type': 'string', 'value': '{{ pillar['smtp']['server'] }}'}
        'ssmtp/hostname': {'type': 'string', 'value': '{{ pillar['mail']['mailname'] }}'}
        'ssmtp/root': {'type': 'string', 'value': '{{ pillar['smtp']['root'] }}'}
        'ssmtp/rewritedomain': {'type': 'string', 'value': ''}
        {# unused by the package itself, why? #}
        'ssmtp/overwriteconfig': {'type': 'boolean', 'value': False}
        'ssmtp/mailname': {'type': 'string', 'value': '{{ pillar['mail']['mailname'] }}'}
        'ssmtp/port': {'type': 'string', 'value': '{{ pillar['smtp']['port'] }}'}
        'ssmtp/fromoverride': {'type': 'boolean', 'value': False}
    - require:
      - pkg: debconf-utils

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
