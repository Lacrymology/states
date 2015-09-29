{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'ssh/test.sls' import add_key, remove_key with context -%}
include:
  - doc
  - ssh.client
  - ssh.server
  - salt.ci
  - salt.ci.diamond
  - salt.ci.nrpe

{%- call test_cron() %}
- sls: salt.ci
- sls: salt.ci.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
    - require:
      - cmd: test_crons
  qa:
    - test_pillar
    - name: salt.ci
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

{{ add_key() }}

test_salt_ci_ssh_port:
  cmd:
    - run
    - name: scp -o 'NoHostAuthenticationForLocalhost yes' -P {{ salt['pillar.get']('salt_ci:ssh_port', 22) }} /etc/hostname root@localhost:/tmp
    - require:
      - cmd: ssh_add_key
      - sls: salt.ci
      - sls: ssh.server
    - require_in:
      - cmd: ssh_remove_key

{{ remove_key() }}
