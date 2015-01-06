{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}

apt.conf:
  file:
    - absent
    - name: /etc/apt/apt.conf.d/99local

/etc/apt/sources.list.save:
  file:
    - absent

apt_sources:
  file:
    - rename
    - name: /etc/apt/sources.list
    - source: /etc/apt/sources.list.bak
    - force: True
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - pkgs:
      - debconf-utils
      - python-apt
      - python-software-properties
#}

apt_clean:
  cmd:
    - run
    - name: apt-get clean

apt-key:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/apt.gpg

{#- cache file from salt.states.pkg  #}
{{ opts['cachedir'] }}/pkg_refresh:
  file:
    - absent

/var/lib/apt/periodic:
  file:
    - absent

{%- for save_file in salt['file.find']('/etc/apt/sources.list.d/', name='*.save', type='f') %}
{{ save_file }}:
  file:
    - absent
{%- endfor -%}
