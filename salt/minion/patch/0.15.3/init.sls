{#-
 This prevent cp.push to work
 #}
salt-common-modules-cp:
  file:
    - patch
    - name: /usr/share/pyshared/salt/modules/cp.py
    - source: salt://salt/minion/patch/0.15.3/module_cp.diff
    - hash: md5=4f7b2fd2ea1b02913a79fe6c21a75528
