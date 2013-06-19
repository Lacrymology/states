{#
 Nagios NRPE check for Sentry
#}
include:
  - apt.nrpe
  - gsyslog.nrpe
  - nginx.nrpe
  - memcache.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - python.dev.nrpe
  - postgresql.server.nrpe
{% if pillar['sentry']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
{% if 'graphite_address' in pillar %}
  - statsd.nrpe
{% endif %}
  - uwsgi.nrpe
  - virtualenv.nrpe

/etc/nagios/nrpe.d/sentry.cfg:
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
      deployment: sentry
      workers: {{ pillar['sentry']['workers'] }}
      cheaper: {{ salt['pillar.get']('sentry:cheaper', False) }}
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/sentry-nginx.cfg:
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
      deployment: sentry
      domain_name: {{ pillar['sentry']['hostnames'][0] }}
      http_uri: /login/
{% if pillar['sentry']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

/etc/nagios/nrpe.d/postgresql-sentry.cfg:
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
      deployment: sentry
      password: {{ pillar['sentry']['db']['password'] }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/sentry.cfg
        - file: /etc/nagios/nrpe.d/sentry-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-sentry.cfg
