{%- from "macros.jinja2" import salt_version with context %}
{%- set version = salt_version() %}

patch_salt_fix_require_sls:
  file:
    - managed
    - name: /usr/share/pyshared/salt/state.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/state.py

/usr/share/pyshared/salt/utils/__init__.py:
  file:
    - managed
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/salt.utils.py
