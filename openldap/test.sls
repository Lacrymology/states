{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - openldap
  - openldap.backup
  - openldap.backup.nrpe
  - openldap.diamond
  - openldap.nrpe

{%- call test_cron() %}
- sls: openldap
- sls: openldap.backup
- sls: openldap.backup.nrpe
- sls: openldap.diamond
- sls: openldap.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('openldap') }}
    - require:
      - sls: openldap
      - sls: openldap.diamond
  qa:
    - test
    - name: openldap
    - additional:
      - openldap.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

{#-
By default, check_ldap already do a search with (objectclass=*).
Moreover, mail stack check also perform query to LDAP.
So, no need to do a test like ldapsearch here.
-#}
