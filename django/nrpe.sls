{#-
Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - nrpe
  - xml

/usr/local/bin/check_robots.py:
  file:
    - absent

python-sitemap:
  file:
    - managed
    - name: /usr/local/nagios/salt-sitemap-requirements.txt
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
    - requirements: /usr/local/nagios/salt-sitemap-requirements.txt
    - require:
      - virtualenv: nrpe-virtualenv
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
