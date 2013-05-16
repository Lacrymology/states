{#
 Nagios NRPE check for Graphite
#}
include:
  - nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
  - virtualenv.nrpe
  - graphite.common.nrpe
  - uwsgi.nrpe
  - nginx.nrpe
  - memcache.nrpe
  - pip.nrpe
  - apt.nrpe
  - python.dev.nrpe
  - statsd.nrpe
  - gsyslog.nrpe
{% if pillar['graphite']['web']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}

/etc/nagios/nrpe.d/graphite.cfg:
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
      deployment: graphite
      workers: {{ pillar['graphite']['web']['workers'] }}
{% if 'cheaper' in pillar['graphite']['web'] %}
      cheaper: {{ pillar['graphite']['web']['cheaper'] }}
{% endif %}

/etc/nagios/nrpe.d/graphite-nginx.cfg:
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
      deployment: graphite
      domain_name: {{ pillar['graphite']['web']['hostnames'][0] }}
      http_uri: /account/login
      https: {{ pillar['graphite']['web']['ssl']|default(False) }}

/etc/nagios/nrpe.d/postgresql-graphite.cfg:
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
      deployment: graphite
      password: {{ pillar['graphite']['web']['db']['password'] }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graphite.cfg
        - file: /etc/nagios/nrpe.d/graphite-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-graphite.cfg
