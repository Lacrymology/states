{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - nrpe
  - xml

/usr/local/bin/check_robots.py:
  file:
    - absent

/usr/local/nagios/salt-django-requirements.txt:
  file:
    - absent

python-sitemap:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/django
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
    - requirements: {{ opts['cachedir'] }}/pip/django
    - require:
      - pkg: xml-dev
    - watch:
      - file: python-sitemap

{%- for check in ('robots', 'sitemap', 'links', 'sitemaplink') %}
check_{{ check }}:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_{{ check }}.py
    - user: root
    - group: nagios
    - mode: 550
    - source: salt://django/check_{{ check }}.py
    - require:
      - module: nrpe-virtualenv
      - module: python-sitemap
    - require_in:
      - file: /var/lib/nagios
{%- endfor %}

/var/lib/nrpe:
  file:
    - absent
