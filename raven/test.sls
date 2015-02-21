{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - raven
  - raven.mail
  - raven.mail.diamond
  - raven.mail.nrpe
  - raven.nrpe
  - requests

{%- set sentry_dsn = salt['pillar.get']('sentry_dsn', False) -%}
{%- if sentry_dsn %}
test:
  module:
    - run
    - name: raven.alert
    - dsn: {{ sentry_dsn }}
    - message: |
        This is just a test to make sure that the raven module is working fine.
        Please ignore.
        In the future, it will be removed automatically after testing.
    - level: INFO
    - require:
      - module: raven
      - module: requests
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: raven
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
{%- endif %}
