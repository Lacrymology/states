{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - apt.nrpe
  - cron.nrpe
  - rsyslog.nrpe
  - nginx.nrpe
  - nrpe
  - rsync.nrpe
  - ssh.server.nrpe
{% if pillar['salt_archive']['web']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}

/etc/nagios/nrpe.d/salt_archive-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: salt_archive
      domain_name: {{ pillar['salt_archive']['web']['hostnames'][0] }}
      http_uri: /
{% if pillar['salt_archive']['web']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt_archive-nginx.cfg
