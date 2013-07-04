include:
  - debian.package_build

{%- set bbb_dir = opts['cachedir'] + "/bbb" -%}
{%- set redis_dir = bbb_dir + "/redis" -%}
{%- set filenames = ('control', 'changelog', 'rules') -%}

{%- set version = "2.2.4" %}

{{ redis_dir }}/debian:
  file:
    - name:
    - directory
    - makedirs: True

{%- for filename in filenames %}
{{ redis_dir }}/debian/{{ filename }}:
  file:
    - managed
    - source: salt://bbb/redis/{{ filename }}.jinja2
    - template: jinja
    - context:
      package_name: redis-server-{{ version }}
      version: {{ version }}
      depends: redis-server
      description: Virtual package that depends on redis-server
{%- endfor %}

redis_package:
  cmd:
    - wait
    - name: dpkg-buildpackage
    - cwd: {{ redis_dir }}
    - watch:
{%- for filename in filenames %}
      - file: {{ redis_dir }}/debian/{{ filename }}
{%- endfor %}
  module:
    - wait
    - name: pkg.install
    - m_name: redis-server-{{ version }}
    - sources:
      - redis-server-{{ version }}: {{ bbb_dir }}/redis-server-{{ version }}_{{ version }}_all.deb
    - watch:
      - cmd: redis_package
