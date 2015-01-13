{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - ssmtp
  - ssmtp.diamond
  - ssmtp.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  cmd:
    - run
    - name: echo -e "SSMTP testing from {{ grains['id'] }}\n\n CI Testing from {{ grains['id'] }}" | ssmtp {{ salt['pillar.get']('smtp:from') }} -v
    - require:
      - file: /etc/ssmtp/ssmtp.conf
      - file: /etc/ssmtp/revaliases
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('ssmtp') }}
    - require:
      - sls: ssmtp
      - sls: ssmtp.diamond
  qa:
    - test_pillar
    - name: ssmtp
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
