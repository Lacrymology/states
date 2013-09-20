{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn
 
 Nagios NRPE check for Sentry
-#}
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
