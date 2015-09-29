{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}

include:
  - doc
  - git.server
  - git.server.diamond
  - git.server.nrpe

{%- call test_cron() %}
- sls: git.server
- sls: git.server.diamond
{%- endcall %}

{#- Can't test diamond metrics, git-shell is not a daemon #}
test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test_pillar
    - name: git.server
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

