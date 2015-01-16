{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - salt

python-pip:
  pkg:
    - installed

unittest-xml-reporting:
  pip:
    - installed
    - name: http://archive.robotinfra.com/mirror/unittest-xml-reporting-a4d6593eb9b85996021285cc2ca3830701fcfe9b.tar.gz
    - require:
      - pkg: python-pip

{%- from "macros.jinja2" import salt_deb_version with context %}
salt-minion:
  pkg:
    - installed
    - version: {{ salt_deb_version() }}
    - require:
      - pkgrepo: salt
      - pkg: python-pip
      - pip: unittest-xml-reporting
  service:
    - running
    - enable: True
    - skip_verify: True
    - watch:
      - pkg: salt-minion
      - cmd: salt
