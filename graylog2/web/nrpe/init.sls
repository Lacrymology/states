{#
 Install a graylog2 web Nagios NRPE checks
#}
include:
  - build.nrpe
  - gsyslog.nrpe
  - mongodb.nrpe
  - nginx.nrpe
  - nrpe
  - ruby.nrpe
{% if pillar['graylog2']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
  - uwsgi.nrpe

/etc/nagios/nrpe.d/graylog2-web.cfg:
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
      deployment: graylog2
      workers: {{ pillar['graylog2']['workers'] }}
{% if 'cheaper' in pillar['graylog2'] %}
      cheaper: {{ pillar['graylog2']['cheaper'] }}
{% endif %}

/etc/nagios/nrpe.d/graylog2-nginx.cfg:
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
      deployment: graylog2
      domain_name: {{ pillar['graylog2']['hostnames'][0] }}
      http_uri: /login
{% if pillar['graylog2']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graylog2-web.cfg
        - file: /etc/nagios/nrpe.d/graylog2-nginx.cfg
