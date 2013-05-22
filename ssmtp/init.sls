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
    - names:
      - ssmtp
      - bsd-mailx
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
        'ssmtp/hostname': {'type': 'string', 'value': '{{ pillar['smtp']['user'] }}'}
        'ssmtp/root': {'type': 'string', 'value': '{{ pillar['smtp']['root'] }}'}
        'ssmtp/rewritedomain': {'type': 'string', 'value': ''}
        {# unused by the package itself, why? #}
        'ssmtp/overwriteconfig': {'type': 'boolean', 'value': False}
        'ssmtp/mailname': {'type': 'string', 'value': '{{ grains['id'] }}'}
        'ssmtp/port': {'type': 'string', 'value': '{{ pillar['smtp']['port'] }}'}
        'ssmtp/fromoverride': {'type': 'boolean', 'value': False}
    - require:
      - pkg: debconf-utils

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
