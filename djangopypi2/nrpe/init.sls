{#
 Nagios NRPE check for djangopypi2
#}
include:
  - apt.nrpe
  - rsyslog.nrpe
  - nginx.nrpe
  - memcache.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
{% if pillar['djangopypi2']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
{% if 'graphite_address' in pillar %}
  - statsd.nrpe
{% endif %}
  - uwsgi.nrpe
  - virtualenv.nrpe

/etc/nagios/nrpe.d/djangopypi2.cfg:
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
      deployment: djangopypi2
      workers: {{ pillar['djangopypi2']['workers'] }}
      cheaper: {{ salt['pillar.get']('djangopypi2:cheaper', False) }}
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/djangopypi2-nginx.cfg:
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
      deployment: djangopypi2
      domain_name: {{ pillar['djangopypi2']['hostnames'][0] }}
      http_uri: /login/
{% if pillar['djangopypi2']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

/etc/nagios/nrpe.d/postgresql-djangopypi2.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: djangopypi2
      password: {{ pillar['djangopypi2']['db']['password'] }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/djangopypi2.cfg
        - file: /etc/nagios/nrpe.d/djangopypi2-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-djangopypi2.cfg
