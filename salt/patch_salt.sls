{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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


{#-
manage sentry_mod.py to fix bug:
https://github.com/saltstack/salt/issues/13172
Remove it after upgrade to version newer than 2014.1.13
#}
sentry_log_handler:
  file:
    - managed
    - name: {{ grains['saltpath']}}/log/handlers/sentry_mod.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/sentry_mod.py
