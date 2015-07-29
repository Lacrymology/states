{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- from "os.jinja2" import os with context %}
include:
  - apt
  - kernel.image.dev

virtualbox:
  pkg:
    - installed
    - pkgs:
      - virtualbox
      - virtualbox-dkms
      - virtualbox-source
      - libgl1-mesa-glx
    - require:
      - cmd: apt_sources
      - pkg: kernel-headers
{#- use RDP for VDRP, required for Windows machine #}
  cmd:
    - wait
    - name: vboxmanage setproperty vrdeextpack 'Oracle VM VirtualBox Extension Pack'
    - require:
      - cmd: virtualbox-oracle-extpack
  service:
    - running
    - watch:
      - pkg: virtualbox
      - pkg: kernel-headers

{#- Oracle VM VirtualBox Extension Pack #}
{%- if os.is_precise %}
  {%- set extpack_file = "Oracle_VM_VirtualBox_Extension_Pack-4.1.12-77245.vbox-extpack" %}
{%- elif os.is_trusty %}
  {%- set extpack_file = "Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack" %}
{%- endif %}
{%- if files_archive %}
  {%- set source = files_archive ~ "/mirror/" ~ extpack_file %}
{%- else %}
  {%- set source = "http://download.virtualbox.org/virtualbox/4.3.10/" ~ extpack_file %}
{%- endif %}

virtualbox-oracle-extpack:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/{{ extpack_file }}
    - source: {{ source }}
    - source_hash: md5=25b70fa71d9320e2836b9be138457ee0
    - user: root
    - group: root
    - mode: 644
    - unless: vboxmanage list extpacks | grep 'Oracle VM VirtualBox Extension Pack'
  cmd:
    - run
    - name: vboxmanage extpack install {{ opts['cachedir'] }}/{{ extpack_file }}
    - unless: vboxmanage list extpacks | grep 'Oracle VM VirtualBox Extension Pack'
    - require:
      - pkg: virtualbox
      - file: virtualbox-oracle-extpack

cleanup_virtualbox-oracle-extpack:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/{{ extpack_file }}
    - require:
      - cmd: virtualbox-oracle-extpack
