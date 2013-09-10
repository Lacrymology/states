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
    - require:
      - pkg: python-pip

extend:
  salt-common-modules-cp:
    file:
      - require:
        - pkg: patch
