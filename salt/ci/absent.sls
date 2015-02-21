{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- for script in ('import_test_data', ) %}
/usr/local/bin/{{ script }}.py:
  file:
    - absent
{%- endfor %}

/etc/salt/master.d/ci.conf:
  file:
    - absent

/etc/sudoers.d/jenkins:
  file:
    - absent

/var/lib/jenkins/salt-test.sh:
  file:
    - absent

/etc/cron.d/salt-archive-ci:
  file:
    - absent

/srv/salt/jenkins_archives:
  file:
    - absent

ci-agent:
  user:
    - absent
  group:
    - absent
    - require:
      - user: ci-agent
  file:
    - absent
    - name: /home/ci-agent
    - require:
      - group: ci-agent

/etc/cron.daily/ci-agent-cleanup-build-logs:
  file:
    - absent
