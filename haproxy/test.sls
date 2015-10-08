{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}

include:
  - doc
  - haproxy
  - haproxy.diamond
  - haproxy.nrpe

test:
  qa:
    - test
    - name: haproxy
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('haproxy') }}
    - require:
      - sls: haproxy
      - sls: haproxy.diamond
