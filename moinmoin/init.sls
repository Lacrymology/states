{#-

optional pillar:

moinmoin:
  sitename: Your company name
  superusers:
    - spiderman
    - batman
  openldap:
    uri: 'ldap://example.com
    binddn: 'cn=admin,dc=example,dc=com'
    bindpw: 'passwordhere'
    basedn: 'dc=example,dc=com'

#}
include:
  - virtualenv
  - uwsgi
  - local
  - nginx
  - pip
{%- if salt['pillar.get']('moinmoin:openldap', False) %}
  - python.dev
{%- endif %}
  - web

{%- set root_dir = '/usr/local/moinmoin' %}

moinmoin:
  virtualenv:
    - manage
    - name: /usr/local/moinmoin
    - no_site_packages: True
    - require:
      - module: virtualenv
      - file: /usr/local
  file:
    - managed
    - name: /usr/local/moinmoin/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://moinmoin/requirements.jinja2
    - require:
      - virtualenv: moinmoin
  cmd:
    - wait
    - name: find /usr/local/moinmoin -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: moinmoin
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/moinmoin/bin/pip
    - requirements: /usr/local/moinmoin/salt-requirements.txt
    - watch:
      - file: moinmoin
    - require:
      - virtualenv: moinmoin
{%- if salt['pillar.get']('moinmoin:openldap', False) %}
      - pkg: moinmoin
      - pkg: python-dev
  pkg:
    - installed
    - pkgs:
      - libldap2-dev
      - libsasl2-dev
      - libssl-dev
{%- endif %}

{{ root_dir }}/share/moin:
  file:
    - directory
    - user: www-data
    - group: www-data
    - recurse:
      - user
      - group
    - require:
      - cmd: moinmoin

{{ root_dir }}/share/moin/moin.wsgi:
  file:
    - symlink
    - target: {{ root_dir }}/share/moin/server/moin.wsgi
    - user: www-data
    - group: www-data
    - require:
      - cmd: moinmoin

moinmoin_config:
  file:
    - managed
    - name: {{ root_dir }}/share/moin/wikiconfig.py
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://moinmoin/config.jinja2
    - require:
      - virtualenv: moinmoin

/etc/uwsgi/moinmoin.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://uwsgi/template.jinja2
    - context:
      chdir: /usr/local/moinmoin/share/moin/
      appname: moinmoin
      wsgi_file: /usr/local/moinmoin/share/moin/moin.wsgi
      virtualenv: {{ root_dir }}
    - require:
      - service: uwsgi_emperor
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/moinmoin.ini
    - require:
      - file: /etc/uwsgi/moinmoin.ini
    - watch:
      - file: moinmoin
      - file: moinmoin_config
      - file: {{ root_dir }}/share/moin
      - file: {{ root_dir }}/share/moin/moin.wsgi

/etc/nginx/conf.d/moinmoin.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://nginx/template.jinja2
    - context:
      appname: moinmoin
      root: {{ root_dir }}/share/moin
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/moinmoin.conf
