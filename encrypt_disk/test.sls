{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - encrypt_disk
  - encrypt_disk.nrpe
  - encrypt_disk.diamond
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
  monitoring:
    - run_all_checks
    - require:
      - sls: encrypt_disk
      - sls: encrypt_disk.nrpe
      - sls: encrypt_disk.diamond
  qa:
    - test
    - name: encrypt_disk
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
