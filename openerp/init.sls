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
  - ldap.dev
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

{%- set home = "/usr/local/openerp" %}
{%- set filename = "openerp-7.0-20130909-231057" %}
{%- set web_root_dir =  home +"/"+ filename %}
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
    - name: {{ home }}/salt-openerp-requirements.txt
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
    - bin_env: {{ home }}/bin/pip
    - requirements: {{ home }}/salt-openerp-requirements.txt
    - install_options:
      - "--prefix={{ home }}"
      - "--install-lib={{ home }}/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/site-packages"
    - require:
      - virtualenv: openerp
    - watch:
      - file: openerp_depends
      - pkg: python-dev
      - pkg: ldap-dev
      - pkg: postgresql-dev
  cmd:
    - wait
    - name: find ./ -name '*.pyc' -delete
    - cwd: {{ home }}
    - stateful: False
    - user: root
    - watch:
      - module: openerp_depends

openerp:
  user:
    - present
    - shell: /bin/false
    - home: {{ home }}
    - groups:
      - www-data
    - require:
      - user: web
      - file: /usr/local
  virtualenv:
    - managed
    - name: {{ home }}
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
    - name: {{ home }}
    - user: openerp
    - group: openerp
    - recurse:
      - user
      - group
    - require:
      - archive: openerp
      - user: openerp
      - cmd: openerp_depends
      - module: openerp_depends
  archive:
    - extracted
    - name: {{ home }}/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/openerp/{{ filename }}.tar.gz
{%- else %}
    - source: http://nightly.openerp.com/7.0/nightly/src/{{ filename }}.tar.gz
{%- endif %}
    - source_hash: md5=0e139452d2f0bcd8f09b0a494b3ac839
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local

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
      home: {{ home }}
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

{%- if salt['pillar.get']('openerp:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ salt['pillar.get']('openerp:ssl') }}/chained_ca.crt
        - module: /etc/ssl/{{ salt['pillar.get']('openerp:ssl') }}/server.pem
        - file: /etc/ssl/{{ salt['pillar.get']('openerp:ssl') }}/ca.crt
{% endif %}
