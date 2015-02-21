{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - ruby.2
  - uwsgi

{%- set version = '1.9.17.1' -%}
{%- set extracted_dir = '/usr/local/uwsgi-{0}'.format(version) %}

uwsgi_patch_fiber:
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/fiber/uwsgiplugin.py
    - source: salt://uwsgi/fiber_uwsgiplugin.patch
    - hash: md5=fccd209c50eff070b62e03c18880f688
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

uwsgi_patch_rack:
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/rack/uwsgiplugin.py
    - source: salt://uwsgi/rack_uwsgiplugin.patch
    - hash: md5=6eb5b904fc74e673b73c02a27c511170
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

uwsgi_patch_rbthreads:
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/rbthreads/uwsgiplugin.py
    - source: salt://uwsgi/rbthreads_uwsgiplugin.patch
    - hash: md5=f7a8556a012dd7cf78e8adaa854a55d2
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: ruby2
    cmd:
      - watch:
        - pkg: ruby2
        - file: uwsgi_patch_fiber
        - file: uwsgi_patch_rack
        - file: uwsgi_patch_rbthreads
      - env:
        - UWSGICONFIG_RUBYPATH: /usr/bin/ruby2.1
