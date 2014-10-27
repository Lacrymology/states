patch_salt_fix_require_sls:
  file:
    - patch
    - name: /usr/share/pyshared/salt/state.py
    - hash: md5=d6ef399200223833bc4e156588eeedca
    - source: salt://salt/require_sls.patch
