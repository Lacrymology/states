{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

/etc/python:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755

python:
  pkg:
    - latest
    - name: python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/python/config.yml
    - source: salt://python/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - require:
      - file: /etc/python

{#-
 Return path to
-#}
{%- macro root_bin_py() -%}
    {%- if grains['lsb_distrib_codename'] == 'precise' -%}
        /usr/share/pyshared
    {%- else -%}
        /usr/lib/python2.7/dist-packages
    {%- endif -%}
{%- endmacro -%}