{#
 Nagios NRPE check for moinmoin
#}
include:
  - apt.nrpe
  - rsyslog.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - python.dev.nrpe
{% if pillar['moinmoin']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
  - uwsgi.nrpe
  - virtualenv.nrpe

/etc/nagios/nrpe.d/moinmoin.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: moinmoin
      workers: {{ pillar['moinmoin']['workers'] }}
      cheaper: {{ salt['pillar.get']('moinmoin:cheaper', False) }}
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/moinmoin-nginx.cfg:
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
      deployment: moinmoin
      domain_name: {{ pillar['moinmoin']['hostnames'][0] }}
{% if pillar['moinmoin']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/moinmoin.cfg
        - file: /etc/nagios/nrpe.d/moinmoin-nginx.cfg
