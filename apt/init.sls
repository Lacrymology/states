{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Configure APT minimal configuration to get Debian packages from repositories.
-#}

include:
  - packages

apt.conf:
  file:
    - managed
    {#- 99 prefix is to make sure the config file is the last one to be
        applied #}
    - name: /etc/apt/apt.conf.d/99local
    - source: salt://apt/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja

dpkg.conf:
  file:
    - managed
    - name: /etc/dpkg/dpkg.cfg
    - source: salt://apt/dpkg.jinja2
    - user: root
    - group: root
    - mode: 444
    - template: jinja

{%- set backup = '/etc/apt/sources.list.salt-backup' %}
{%- if salt['file.file_exists'](backup) %}
apt.conf.bak:
  file:
    - rename
    - name: {{ backup }}
    - source: /etc/apt/sources.list
    - require_in:
      - file: apt
{%- endif %}

{#- make sure basic ubuntu keys are there #}
apt-key:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/apt.gpg
    - source: salt://apt/key.gpg
    - user: root
    - group: root
    - mode: 440
  cmd:
    - wait
    - name: apt-key add {{ opts['cachedir'] }}/apt.gpg
    - watch:
      - file: apt-key

{#- minimum configuration of apt and make sure basic packages required by salt
    to work correctly (mostly for pkgrepo, but that aren't required dependencies
    are installed. #}
apt:
  file:
    - managed
    - name: /etc/apt/sources.list
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - contents: |
        # {{ pillar['message_do_not_modify'] }}
        {{ pillar['apt']['sources'] | indent(8) }}
  module:
    - wait
    - name: pkg.refresh_db
    - watch:
      - file: apt
      - file: apt.conf
    - require:
      - file: dpkg.conf
      - cmd: apt-key
{%- set packages_blacklist = salt['pillar.get']('packages:blacklist', False) -%}
{%- set packages_whitelist = salt['pillar.get']('packages:whitelist', False) -%}
{%- if packages_blacklist or packages_whitelist %}
    - require_in:
    {%- if packages_blacklist %}
      - pkg: packages_blacklist
    {%- endif -%}
    {%- if packages_whitelist %}
      - pkg: packages_whitelist
    {%- endif -%}
{%- endif %}

{#- simple state, just keep the API as others used it #}
apt_sources:
  pkg:
    - installed
    - pkgs:
      - debconf-utils
      - python-apt
      - python-software-properties
    - require:
      - module: apt
  cmd:
    - wait
    - name: touch /etc/apt/sources.list
    - watch:
      - pkg: apt_sources
      - module: apt
{%- if salt['pillar.get']('apt:upgrade', False) %}
  module:
    - run
    - name: pkg.upgrade
    - upgrade: True
    - require:
      - module: apt
    - watch_in:
      - cmd: apt_sources
{%- endif %}
