{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Dang Tung Lam <lam@robotinfra.com>
-#}
php:
  file:
    - absent
    - name: /etc/apt/sources.list.d/lucid-php5.list
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - name: php5
#}
  cmd:
    - run
    - name: 'apt-key del 67E15F46'
    - onlyif: apt-key list | grep -q 67E15F46
  pkgrepo:
    - absent
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/lucid-php5 {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - ppa: l-mierzwa/lucid-php5
{%- endif %}

/etc/apt/sources.list.d/l-mierzwa-lucid-php5-{{ grains['oscodename'] }}.list:
  file:
    - absent
    - require:
      - pkgrepo: php
