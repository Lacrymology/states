{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - kernel.image
  - kernel.modules

test:
  qa:
    - test_pillar
    - name: kernel
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
