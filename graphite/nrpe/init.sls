{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Nagios NRPE check for Graphite
-#}
include:
  - apt.nrpe
  - graphite.common.nrpe
  - rsyslog.nrpe
  - memcache.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
  - statsd.nrpe
  - uwsgi.nrpe
  - virtualenv.nrpe
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
{% if pillar['graphite']['web']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

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
