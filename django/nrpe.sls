{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
