{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{#- use this ID to make it conflict with python/init.sls #}
/etc/python:
  file:
    - absent
    - require:
      - file: python

/etc/python/logging.conf:
  file:
    - absent

python:
  file:
    - absent
    - name: /etc/python/config.yml

{%- for log_file in salt['file.find']('/usr/lib/python2.7/', name='*.pyo', type='f') %}
{{ log_file }}:
  file:
    - absent
{%- endfor -%}
