{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
include:
  - salt.api.absent

{{ upstart_absent('salt-master') }}

extend:
  salt-master:
{#- Workaround bug that sometime salt-master process doesn't stop after integration.py cleanup phase #}
    cmd:
      - run
      - onlyif: pgrep salt-master
      - name: kill -9 `pgrep salt-master` || true
      - require:
        - pkg: salt-master
    pkg:
      - purged
      - require:
        - service: salt-master

{#-
{% if salt['cmd.has_exec']('pip') %}
GitPython:
  pip:
    - removed
{% endif %}
-#}

{%- for file in ('pillars', 'salt', 'reactor') %}
/srv/{{ file }}:
  file:
    - absent
    - require:
      - pkg: salt-master
{%- endfor -%}

{%- for prefix in ('job_changes', 'event_debug') %}
salt-master-{{ prefix }}.py:
  file:
    - absent
    - name: /usr/local/bin/salt-master-{{ prefix }}.py
{%- endfor %}

salt-master-requirements:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/salt.master

/var/cache/salt/master:
  file:
    - absent
    - require:
      - pkg: salt-master

/etc/salt/master.d:
  file:
    - absent
    - require:
      - pkg: salt-master

/etc/cron.daily/salt_master_highstate:
  file:
    - absent

/usr/local/bin/salt_master_highstate.sh:
  file:
    - absent

/etc/cron.d/salt_master_highstate:
  file:
    - absent

salt_master_script_git_pull_repos:
  file:
    - absent
    - name: /usr/local/bin/salt_master_git_pull_repos.sh

salt_master_cron_git_pull_repos:
  file:
    - absent
    - name: /etc/cron.d/salt-master-pull-repos
