{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

php:
  file:
    - absent
    - name: /etc/apt/sources.list.d/php.list
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

php-5.6:
  cmd:
    - run
    - name: apt-key del E5267A6C
    - onlyif: apt-key list | grep -q E5267A6C
