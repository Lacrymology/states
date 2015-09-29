{# -*- ci-automatic-discovery: off -*- #}

include:
  - doc

doc-pillar-reset:
  module:
    - run
    - name: pillar.reset

{# this one must fail #}
doc-pillar-undefined-no-default:
  module:
    - run
    - name: pillar.get
    - key: invalid_pillar_key
    - require:
      - module: doc-pillar-reset

doc-pillar-undocumented:
  module:
    - run
    - name: pillar.get
    - key: invalid_pillar_key
    - default: 1234
    - require:
      - module: doc-pillar-reset

doc-pillar-documented:
  module:
    - run
    - name: pillar.get
    - key: branch
    - default: master
    - require:
      - module: doc-pillar-reset

doc-pillar-documented-different-default:
  {# this one must fail #}
  module:
    - run
    - name: pillar.get
    - key: branch
    - default: master-2
    - require:
      - module: doc-pillar-documented
  qa:
    - test_pillar
    - name: common
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
