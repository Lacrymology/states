include:
  - salt

salt-minion:
  pkg:
    - latest
    - require:
      - apt_repository: salt
  service:
    - running
    - enable: True
    - skip_verify: True
    - require:
      - module: sync_all
      - pip: unittest-xml-reporting
    - watch:
      - pkg: salt-minion

sync_all:
  module:
    - run
    - name: saltutil.sync_all

python-pip:
  pkg:
    - installed

unittest-xml-reporting:
  pip:
    - installed
    - name: http://archive.robotinfra.com/mirror/unittest-xml-reporting-a4d6593eb9b85996021285cc2ca3830701fcfe9b.tar.gz
    - require:
      - pkg: python-pip
