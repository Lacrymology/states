{#- Usage of this is governed by a license that can be found in doc/license.rst

Install ruby version 2.1
-#}
{%- from "ruby/2/map.jinja2" import ruby_2 with context %}
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

{%- set version = ruby_2.version %}
{%- set arch = grains['osarch'] %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
  {%- set repo_url = files_archive|replace('file://', '')|replace('https://', 'http://') ~ "/mirror" %}
{%- else %}
  {#- source: ppa:brightbox/ruby-ng #}
  {%- set repo_url = "http://archive.robotinfra.com/mirror" %}
{%- endif %}

{#- have to uninstall old version first until this bug is fixed: https://github.com/saltstack/salt/issues/7772 #}
{%- set current_version = salt["pkg.version"]("ruby2.1") %}
{%- if current_version and current_version != version %}
clean_old_ruby_2_pkgs:
  pkg:
    - purged
    - pkgs:
      - libruby2.1
      - ruby2.1
      - ruby2.1-dev
      - rubygems-integration
    - require_in:
      - pkg: ruby2
{%- endif %}

ruby2:
  pkg:
    - installed
    - sources:
      - rubygems-integration: {{ repo_url }}/rubygems-integration/rubygems-integration_1.8-1bbox1~{{ grains["oscodename"]}}1_all.deb
      - ruby2.1: {{ repo_url }}/ruby2.1/ruby2.1_{{ version }}_{{ arch }}.deb
      - ruby2.1-dev: {{ repo_url }}/ruby2.1/ruby2.1-dev_{{ version }}_{{ arch }}.deb
      - libruby2.1: {{ repo_url }}/ruby2.1/libruby2.1_{{ version }}_{{ arch }}.deb
    - require:
      - cmd: system_locale
      - pkg: ruby2_deps
      - cmd: ca-certificates
