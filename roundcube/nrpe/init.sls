{#
 Install a roundcube Nagios NRPE checks
#}
include:
  - nrpe
  - nginx.nrpe
  - uwsgi.nrpe
  - build.nrpe
  - gsyslog.nrpe
{% if pillar['roundcube']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}

/etc/nagios/nrpe.d/roundcube-web.cfg:
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
      deployment: roundcube
      workers: {{ pillar['roundcube']['workers'] }}
{% if 'cheaper' in pillar['roundcube'] %}
      cheaper: {{ pillar['roundcube']['cheaper'] }}
{% endif %}

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
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
      deployment: roundcube
      domain_name: {{ pillar['roundcube']['hostnames'][0] }}
      http_uri: /
      https: {{ pillar['roundcube']['ssl']|default(False) }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/roundcube-web.cfg
        - file: /etc/nagios/nrpe.d/roundcube-nginx.cfg
