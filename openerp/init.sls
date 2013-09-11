{#- 
Install OpenERP
===============


Mandatory Pillar
----------------
openerp:
  hostnames: 
    - list of hostname, used for nginx config

Optional Pillar
---------------
openerp:
  ssl: - enable ssl. Default: False
  database:
    password: password for postgres user

#}

include:
  - apt
  - build
  - nginx
  - pip
  - postgresql.server
  - python.dev
{%- if pillar['openerp']['ssl']|default(False) %}
  - ssl
{%- endif %}
  - underscore
  - uwsgi
  - virtualenv
  - web

{%- set web_root_dir = "/usr/local/openerp" %}
{%- set password = salt['password.pillar']('openerp:database:password', 10)  %}

openerp_depends:
  pkg:
    - installed
    - pkgs:
      - python-libxslt1
    - require:
      - cmd: apt_sources
      - pkg: build
      - pkg: libjs-underscore
  file:
    - managed
    - name: {{ web_root_dir }}/salt-openerp-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openerp/requirements.jinja2
    - require:
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: {{ web_root_dir }}/bin/pip
    - requirements: {{ web_root_dir }}/salt-openerp-requirements.txt
    - install_options:
      - "--prefix={{ web_root_dir }}"
      - "--install-lib={{ web_root_dir }}/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/site-packages"
    - require:
      - virtualenv: openerp
    - watch:
      - file: openerp_depends
      - pkg: python-dev
  cmd:
    - wait
    - name: find ./ -name '*.pyc' -delete
    - cwd: {{ web_root_dir }}
    - stateful: False
    - user: root
    - watch:
      - module: openerp_depends

openerp:
  user:
    - present
    - shell: /bin/false
    - home: {{ web_root_dir }}
    - groups:
      - www-data
    - require:
      - user: web
      - file: /usr/local
  virtualenv:
    - managed
    - name: {{ web_root_dir }}
    - require:
      - user: openerp
      - module: virtualenv
  postgres_user:
    - present
    - name: openerp
    - password: {{ password }}
    - createdb: True
    - require:
      - service: postgresql
  file:
    - directory
    - name: {{ web_root_dir }}
    - user: openerp
    - group: openerp
    - recurse:
      - user
      - group
    - require:
      - user: openerp
      - cmd: openerp_depends
      - module: openerp_depends

{{ web_root_dir }}/openerp.wsgi:
  file:
    - managed
    - user: openerp
    - group: openerp
    - mode: 440
    - template: jinja
    - source: salt://openerp/openerp.jinja2
    - require:
      - file: openerp
      - postgres_user: openerp
    - context:
      password: {{ password }}
      web_root_dir: {{ web_root_dir }}

add_web_user_to_openerp_group:
  user:
    - present
    - name: www-data
    - groups:
      - openerp
    - require:
      - user: web
      - user: openerp

/etc/uwsgi/openerp.ini:
  file:
    - managed
    - template: jinja
    - source: salt://openerp/uwsgi.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: {{ web_root_dir }}/openerp.wsgi
      - user: add_web_user_to_openerp_group
      - service: uwsgi_emperor
    - context:
      web_root_dir: {{ web_root_dir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/openerp.ini
    - require:
      - file: openerp
    - watch:
      - file: {{ web_root_dir }}/openerp.wsgi
      - module: openerp_depends

/etc/nginx/conf.d/openerp.conf:
  file:
    - managed
    - source: salt://openerp/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - file: /etc/uwsgi/openerp.ini
{%- if salt['pillar.get']('openerp:ssl', False) %}
      - cmd: /etc/ssl/{{ salt['pillar.get']('openerp:ssl') }}/chained_ca.crt
      - module: /etc/ssl/{{ salt['pillar.get']('openerp:ssl') }}/server.pem
      - file: /etc/ssl/{{ salt['pillar.get']('openerp:ssl') }}/ca.crt
{%- endif %}
    - watch_in:
      - service: nginx
    - context:
      web_root_dir: {{ web_root_dir }}
