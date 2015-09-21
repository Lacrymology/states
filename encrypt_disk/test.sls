{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - encrypt_disk
  - doc

{%- set enc = salt["pillar.get"]("encrypt_disk", {}) %}
{%- for disk in enc %}
allocate_disk_{{ disk }}:
  cmd:
    - run
    - name: fallocate -l 512M '{{ disk }}'
    - require_in:
      - cmd: luksFormat_disk_{{ disk }}
{%- endfor %}

test:
  qa:
    - test_pillar
    - name: encrypt_disk
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - sls: encrypt_disk
      - cmd: doc
