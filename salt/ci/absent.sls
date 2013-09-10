{%- for script in ('import_test_data.py', 'retcode_check.py') %}
/usr/local/bin/{{ script }}:
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
