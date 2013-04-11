include:
  - apt
  - hostname
  - diamond

ssmtp:
  pkg:
    - installed
    - require:
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

ssmtp_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[ssmtp]]
        exe = ^\/usr\/sbin\/ssmtp$

bsd-mailx:
  pkg:
    - installed
    - require:
      - pkg: ssmtp

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
