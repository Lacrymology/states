{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>

Install ruby version 2.1
-#}

include:
  - apt
  - locale
  - ssl

{#-
  ruby2.1 requires ruby, see:
  https://bugs.launchpad.net/ubuntu/+source/ruby2.0/+bug/1310292
#}
ruby2_deps:
  pkg:
    - installed
    - pkgs:
      - libffi6
      - libgdbm3
      - libgmp-dev
      - libgmp10
      - libjs-jquery
      - libreadline6
      - libyaml-0-2
      - ruby
      - zlib1g
    - require:
      - cmd: apt_sources

{%- set version = "2.1.2-1bbox1~precise1" %}
{%- set arch = grains['osarch'] %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
  {%- set repo_url = files_archive|replace('file://', '')|replace('https://', 'http://') ~ "/mirror" %}
{%- else %}
  {%- set repo_url = "http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu/pool/main/r" %}
{%- endif %}

ruby2:
  pkg:
    - installed
    - sources:
      - rubygems-integration: {{ repo_url }}/rubygems-integration/rubygems-integration_1.5-1bbox1_all.deb
      - ruby2.1: {{ repo_url }}/ruby2.1/ruby2.1_{{ version }}_{{ arch }}.deb
      - ruby2.1-dev: {{ repo_url }}/ruby2.1/ruby2.1-dev_{{ version }}_{{ arch }}.deb
      - libruby2.1: {{ repo_url }}/ruby2.1/libruby2.1_{{ version }}_{{ arch }}.deb
    - require:
      - pkg: ssl-cert
      - cmd: system_locale
      - pkg: ruby2_deps
