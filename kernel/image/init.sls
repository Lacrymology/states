{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

kernel:
  pkg:
    - installed
    - name: linux-image-{{ grains['kernelrelease'] }}
    - required:
      - cmd: apt_sources

{%- set kernel_files = salt['file.find'](path='/boot', name='vmlinuz-*', type='f', print='name') %}

{%- for file in kernel_files if file.replace('vmlinuz-', '') != grains['kernelrelease'] %}
  {%- for type in ('image', 'headers') %}
{{ file.replace('vmlinuz', 'linux-' ~ type) }}:
  pkg:
    - purged
  {%- endfor %}
{%- endfor %}
