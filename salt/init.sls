{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

How to create a snapshot of saltstack Ubuntu PPA::

  wget -m -I /saltstack/salt/ubuntu/ \
    http://ppa.launchpad.net/saltstack/salt/ubuntu/
  mv ppa.launchpad.net/saltstack/salt/ubuntu/dists \
    ppa.launchpad.net/saltstack/salt/ubuntu/pool .
  rm -rf ppa.launchpad.net
  find . -type f -name 'index.*' -delete
  find pool/ -type f ! -name '*.deb' -delete

To only keep precise & trusty::

   rm -rf `find dists/ -maxdepth 1 -mindepth 1 ! -name precise ! -name trusty`
   # because some deb can be used for all (E.g: salt-api)
   find pool/ \( -type f -name '*.deb' \( -name '*lucid*' -or  -name '*oneiric*' -or  -name '*quantal*' -or  -name '*raring*' -or -name '*saucy*' \) \) -delete
-#}
include:
  - apt
  - salt.patch_salt

{%- for i in ('list', 'list.save') %}
salt_absent_old_apt_salt_{{ i }}:
  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_codename'] }}.{{ i }}
{%- endfor %}

{%- from "macros.jinja2" import salt_version with context %}
{%- set version = salt_version() %}
salt:
  pkg:
    - installed
    - name: salt-common
    - require_in:
      - file: patch_salt_fix_require_sls
  pkgrepo:
    - managed
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/salt/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://archive.robotinfra.com/mirror/salt/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- endif %}
    - file: /etc/apt/sources.list.d/saltstack-salt.list
    - key_url: salt://salt/key.gpg
    - require:
      - cmd: apt_sources
      - file: salt_absent_old_apt_salt_list
      - file: salt_absent_old_apt_salt_list.save
    - require_in:
      - pkg: salt
  cmd: {#- the state which act as an API, consumer only need to watch this if it need to watch changes of this SLS #}
    - wait
    - name: echo "state(s) in ``salt`` have been changed"
    - watch:
      - pkg: salt
      - file: patch_salt_fix_require_sls

salt_patch_util:
  pkg:
    - installed
    - name: patch
    - require:
      - cmd: apt_sources
    - require_in:
      - file: patch_salt_fix_require_sls

/var/cache/salt:
  file:
    - directory
    - user: root
    - group: root
    - mode: 750
