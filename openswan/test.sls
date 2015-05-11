{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context -%}

include:
  - doc
  - openswan
  - openswan.diamond
  - openswan.nrpe
  - pppd
  - pppd.diamond
  - pppd.nrpe
  - xl2tpd
  - xl2tpd.diamond
  - xl2tpd.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: openswan
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('openswan') }}
    - require:
      - sls: openswan.diamond
      - sls: openswan

{#- Workaround for file.accumulated bug
    https://github.com/saltstack/salt/issues/8881 #}
extend:
  openswan_diamond_resources:
    file:
      - require:
        {#- Make sure that file.accumulated is run after reload_modules #}
        - sls: doc
        - sls: openswan
        - sls: pppd
        - sls: xl2tpd
