{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context -%}

include:
  - doc
  - strongswan.server
  - strongswan.server.diamond
  - strongswan.server.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: strongswan.server
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('strongswan') }}
    - require:
      - sls: strongswan.server.diamond
      - sls: strongswan.server

{#- Workaround for file.accumulated bug
    https://github.com/saltstack/salt/issues/8881 #}
extend:
  strongswan_diamond_resources:
    file:
      - require:
        {#- Make sure that file.accumulated is run after reload_modules #}
        - sls: doc
        - sls: strongswan.server
