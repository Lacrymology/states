{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - local
  - php

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set version = "1.0.0-alpha10" %}
{%- set hash = "md5=dea8681b6f54dca9bb3a5b7deb179cca" %}
{%- if files_archive %}
  {%- set source = files_archive ~ "/mirror/composer-" ~ version ~ ".phar" %}
{%- else %}
  {%- set source = "https://getcomposer.org/download/" ~ version ~ "/composer.phar" %}
{%- endif %}
composer:
  file:
    - managed
    - name: /usr/local/bin/composer
    - source: {{ source }}
    - source_hash: {{ hash }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local
      - pkg: php
