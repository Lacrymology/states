{#-
APT Configuration
=================

Configure APT minimal configuration to get Debian packages from repositories.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file
apt:
  sources: |
    deb http://mirror.anl.gov/pub/ubuntu/ {{ grains['oscodename'] }} main restricted universe multiverse
    deb http://security.ubuntu.com/ubuntu {{ grains['oscodename'] }}-security main restricted universe multiverse
    deb http://archive.canonical.com/ubuntu {{ grains['oscodename'] }} partner

Optional Pillar
---------------

proxy_server: False
packages:
  blacklist:
    - more
    - vi
  whitelist:
    - vim
    - cmon
    - nmap

proxy_server: If True, the specific HTTP proxy server (without authentication)
    is used to download .deb and reach APT server. Default: False.

packages:blacklist: list of packages to remove
packages:whitelist: list of packages to install
-#}

include:
  - packages

{#- 99 prefix is to make sure the config file is the last one to be applied #}
/etc/apt/apt.conf.d/99local:
  file:
    - managed
    - source: salt://apt/config.jinja2
    - user: root
    - group: root
    - mode: 444
    - template: jinja

{%- set backup = '/etc/apt/sources.list.salt-backup' %}

apt_sources:
  file:
    - managed
    - name: /etc/apt/sources.list
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - contents: |
        # {{ pillar['message_do_not_modify'] }}
        {{ pillar['apt']['sources'] | indent(8) }}
    - require:
      - file: /etc/apt/apt.conf.d/99local
{%- if salt['file.file_exists'](backup) %}
      - file: apt_sources_backup
{%- endif %}
  pkg:
    - installed
    - pkgs:
        - debconf-utils
        - python-apt
        - python-software-properties
    - require:
      - cmd: apt_sources
{#-
  cmd.wait is used instead of:

  module:
    - name: pkg.refresh_db

  because the watch directive didn't seem to be respected back in older version.
  this should be test to switch back to module.name instead.
#}
  cmd:
    - wait
    - name: apt-get update
    - watch:
      - file: apt_sources
      - file: /etc/apt/apt.conf.d/99local
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
{%- endif -%}

{%- if salt['file.file_exists'](backup) %}
apt_sources_backup:
  file:
    - rename
    - name: {{ backup }}
    - source: /etc/apt/sources.list
{%- endif -%}
