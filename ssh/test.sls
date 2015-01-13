{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- set authorized_keys_exists = salt["file.file_exists"](root_home ~ "/.ssh/authorized_keys") %}
{%- set root_home = salt['user.info']('root')['home'] %}
{%- macro add_key() -%}
{#-
  Add public key to the `authorized_keys` on localhost.
  This is used to perform some tests like: ssh, rsync, ...
#}
  {%- if authorized_keys_exists %}
ssh_backup_key:
  file:
    - copy
    - name: {{ root_home }}/.ssh/authorized_keys.bak
    - source: {{ root_home }}/.ssh/authorized_keys
    - require:
      - sls: ssh.client
  {%- endif %}

ssh_add_key:
  cmd:
    - run
    - name: cat {{ root_home }}/.ssh/id_*.pub >> {{ root_home }}/.ssh/authorized_keys
  {%- if authorized_keys_exists %}
    - require:
      - file: ssh_backup_key
  {%- endif %}
{%- endmacro %}

{%- macro remove_key() -%}
{#- Remove local ssh public key after testing #}
ssh_remove_key:
  cmd:
    - run
  {%- if authorized_keys_exists %}
    - name: mv {{ root_home }}/.ssh/authorized_keys.bak {{ root_home }}/.ssh/authorized_keys
  {%- else %}
    - name: rm {{ root_home }}/.ssh/authorized_keys
  {%- endif %}
{%- endmacro %}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - ssh.client
  - ssh.client.nrpe
  - ssh.server
  - ssh.server.diamond
  - ssh.server.nrpe

{{ add_key() }}

test_ssh:
  cmd:
    - run
    - name: ssh -o NoHostAuthenticationForLocalhost=yes root@localhost '/bin/true'
    - require:
      - cmd: ssh_add_key
    - require_in:
      - cmd: ssh_remove_key

{{ remove_key() }}

test:
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('sshd') }}
    - require:
      - sls: ssh.server
      - sls: ssh.server.diamond
