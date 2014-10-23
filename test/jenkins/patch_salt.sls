patch_salt_fix_require_sls:
  file:
    - patch
    - name: /usr/share/pyshared/salt/state.py
    - hash: md5=cb303bf87a7584e1de6843049c122dd8
    - source: salt://salt/require_sls.patch
