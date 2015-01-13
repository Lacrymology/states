{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}

# config varnish storage backend
{% set storage_backend = salt['pillar.get']('varnish:storage_backend', 'malloc') %}

{% if storage_backend not in ['malloc', 'file'] %}
  {% set storage_backend = 'malloc' %}
{% endif %}

{% if storage_backend == 'file' %}
  {% if not salt['pillar.get']('varnish:file_path', None) %}
    {% set file_path = '/var/lib/varnish/' ~ grains['host'] ~ '/varnish_storage.bin' %}
  {% endif %}
  {% set file_size = salt['pillar.get']('varnish:file_size', '2G') | upper %}
  {% set file_size_unit = file_size | list | last %}
{% endif %}

include:
  - apt
  - bash

varnish:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - order: 50
  {% if storage_backend == 'file' %}
    - require:
      - cmd: varnish
  {% endif %}
    - watch:
      - pkg: varnish
      - file: /etc/varnish/default.vcl
      - file: /etc/default/varnish
      - user: varnish_user
{# preallocate file to prevent fragment #}
{# K is too small and T is too large #}
{% if storage_backend == 'file' and file_size_unit in ['M', 'G'] %}
  cmd:
    - script
    - source: salt://varnish/allocate.sh
    - name: allocate {{ file_path }} {{ file_size }}
    - unless: test -f "{{ file_path }}"
    - require:
      - pkg: varnish
      - file: bash
{% endif %}

{%- for user in ('varnish', 'varnishlog') %}
{{ user }}_user:
  user:
    - present
    - name: {{ user }}
    - shell: /bin/false
    - require:
      - pkg: varnish
{%- endfor %}

/etc/varnish/default.vcl:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://varnish/default.vcl.jinja2
    - require:
      - pkg: varnish
{#- PID file owned by root, no need to manage #}

/etc/default/varnish:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://varnish/config.jinja2
    - context:
        storage_backend: {{ storage_backend }}
    {% if storage_backend == 'file' %}
        file_size: {{ file_size }}
        file_path: {{ file_path }}
    {% endif %}
    - require:
      - pkg: varnish
