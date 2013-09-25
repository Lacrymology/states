{#-
Copyright (c) 2013, Lam Dang Tung

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>

 Install a GitLab Nagios NRPE checks
-#}
include:
  - apt.nrpe
  - build.nrpe
  - git.nrpe
  - logrotate.nrpe
  - nginx.nrpe
  - nodejs.nrpe
  - nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
  - python.nrpe
  - redis.nrpe
  - ruby.nrpe
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - uwsgi.nrpe
  - xml.nrpe

/etc/nagios/nrpe.d/gitlab.cfg:
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
      deployment: gitlab
      workers: {{ salt['pillar.get']('gitlab:workers', "2") }}
{%- if 'cheaper' in pillar['gitlab'] %}
      cheaper: {{ pillar['gitlab']['cheaper']  }}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/gitlab-nginx.cfg:
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
      deployment: gitlab
      domain_name: {{ pillar['gitlab']['hostnames'][0] }}
      http_uri: /users/sign_in
{%- if salt['pillar.get']('gitlab:ssl', False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}
{%- if salt['pillar.get']('__test__', False) %}
      timeout: 120
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/postgresql-gitlab.cfg:
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
      deployment: gitlab
      password: {{  salt['password.pillar']('gitlab:database:password', 10) }}
    - watch_in:
      - service: nagios-nrpe-server
