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

 Install a wordpress Nagios NRPE checks
-#}
include:
  - nrpe
  - build.nrpe
  - mariadb.nrpe
  - mariadb.server.nrpe
  - nginx.nrpe
  - php.nrpe
{%- if salt['pillar.get']('wordpress:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - uwsgi.nrpe

/etc/nagios/nrpe.d/wordpress.cfg:
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
      deployment: wordpress
      workers: {{ salt['pillar.get']('wordpress:workers', '2') }}
{%- if 'cheaper' in pillar['wordpress'] %}
      cheaper: {{ salt['pillar.get']('wordpress:cheaper') }}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/wordpress-nginx.cfg:
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
      deployment: wordpress
      domain_name: {{ salt['pillar.get']('wordpress:hostnames')[0] }}
      http_uri: /
{%- if salt['pillar.get']('wordpress:ssl', False) %}
      https: True
    {%- if salt['pillar.get']('wordpress:ssl_redirect', False) %}
      http_result: 301 Moved Permanently
    {%- endif -%}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/wordpress-mysql.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://mariadb/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: wordpress
      username: wordpress
      password: {{ salt['password.pillar']('wordpress:password', 10) }}