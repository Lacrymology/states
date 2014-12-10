{#-
Copyright (c) 2013, Diep Pham
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

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
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
