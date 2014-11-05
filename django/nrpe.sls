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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
include:
  - nrpe
  - xml

/usr/local/bin/check_robots.py:
  file:
    - absent

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/nagios/salt-sitemap-requirements.txt:
  file:
    - absent

python-sitemap:
  file:
    - managed
    - name: /usr/local/nagios/salt-django-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://django/requirements.jinja2
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/salt-django-requirements.txt
    - require:
      - pkg: xml-dev
    - watch:
      - file: python-sitemap

{%- for check in ('robots', 'sitemap', 'links', 'sitemaplink') %}
check_{{ check }}:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_{{ check }}.py
    - user: nagios
    - group: nagios
    - mode: 550
    - source: salt://django/check_{{ check }}.py
    - require:
      - pkg: nagios-nrpe-server
      - module: python-sitemap
{%- endfor %}

/var/lib/nagios:
  file:
    - directory
    - user: nagios
    - group: nagios
    - mode: 755
    - require:
      - file: check_robots
      - file: check_sitemap
      - file: check_links
      - file: check_sitemaplink

/var/lib/nrpe:
  file:
    - absent
