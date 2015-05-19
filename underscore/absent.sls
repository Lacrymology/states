{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}

libjs-underscore:
{%- if os.is_precise %}
  pkgrepo:
    - absent
    - ppa: chris-lea/libjs-underscore
  file:
    - absent
    - name: /etc/apt/sources.list.d/chris-lea-libjs-underscore-{{ grains['oscodename'] }}.list
    - require:
      - pkgrepo: libjs-underscore
{%- endif %}
  pkg:
    - purged
