{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
git:
  pkg:
    - purged
  cmd:
    - run
    - name: 'apt-key del E1DF1F24'
    - onlyif: apt-key list | grep -q E1DF1F24
  pkgrepo:
    - absent
{%- if salt['pillar.get']('files_archive', False) %}
    - name: deb {{ salt['pillar.get']('files_archive', False)|replace('https://', 'http://') }}/mirror/git {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - ppa: git-core/ppa
{%- endif %}
  file:
    - absent
    - name: /etc/apt/sources.list.d/git-core.list
    - require:
      - pkgrepo: git
