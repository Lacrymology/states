{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
apt-key del 0E27C0A6:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 0E27C0A6

{%- set version = '0.17.5-1' %}
{%- for i in ('list', 'list.save') %}
salt_absent_old_apt_salt_{{ i }}:
  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_codename'] }}.{{ i }}
{%- endfor %}

salt:
  pkgrepo:
    - absent
{%- if salt['pillar.get']('files_archive', False) %}
    - name: deb {{ salt['pillar.get']('files_archive', False)|replace('https://', 'http://') }}/mirror/salt/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://archive.robotinfra.com/mirror/salt/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- endif %}
    - file: /etc/apt/sources.list.d/saltstack-salt.list
  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt.list
    - require:
      - pkgrepo: salt
