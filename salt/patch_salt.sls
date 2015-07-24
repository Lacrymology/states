{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

patch_salt_fix_require_sls:
  file:
    - managed
    - name: {{ grains['saltpath'] }}/state.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/state.py

patch_salt_utils:
  file:
    - managed
    - name: {{ grains['saltpath'] }}/utils/__init__.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/utils.py

patch_salt_log_setup_fix_deadlock:
  file:
    - managed
    - name: {{ grains['saltpath'] }}/log/setup.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://salt/patch/log_setup.py
