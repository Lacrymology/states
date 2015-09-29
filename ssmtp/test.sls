{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - ssmtp
  - ssmtp.diamond
  - ssmtp.nrpe

{#- can't test diamond metrics, ssmtp is not a diamond #}
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
  qa:
    - test_pillar
    - name: ssmtp
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
