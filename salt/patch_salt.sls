{%- from "python/init.sls" import root_bin_py with context -%}

patch_salt_fix_require_sls:
  file:
    - managed
    - name: {{ root_bin_py() }}/salt/state.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/state.py

patch_salt_utils:
  file:
    - managed
    - name: {{ root_bin_py() }}/salt/utils/__init__.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/utils.py
