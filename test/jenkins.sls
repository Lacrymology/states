include:
  - salt.minion.patch.0_15_3

patch:
  pkg:
    - installed

salt-minion:
  module:
    - run
    - name: saltutil.sync_all
  service:
    - running
    - require:
      - module: salt-minion
    - watch:
      - file: salt-common-modules-cp

python-pip:
  pkg:
    - installed

unittest-xml-reporting:
  pip:
    - installed
    - name: http://archive.robotinfra.com/mirror/unittest-xml-reporting-a4d6593eb9b85996021285cc2ca3830701fcfe9b.tar.gz
    - require:
      - pkg: python-pip

extend:
  salt-common-modules-cp:
    file:
      - require:
        - pkg: patch
