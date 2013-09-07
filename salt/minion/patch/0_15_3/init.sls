{#-
 This prevent cp.push to work
 #}
salt-common-modules-cp:
  file:
    - patch
    - name: /usr/share/pyshared/salt/modules/cp.py
    - source: salt://salt/minion/patch/0_15_3/module_cp.diff
    - hash: md5=00f063a455ea36a485c32227f0694842
