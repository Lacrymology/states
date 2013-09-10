include:
  - jenkins
  - local
  - rsync
  - salt.cloud
  - salt.archive.server
  - salt.master
  - ssh.client
  - sudo

extend:
  /etc/salt/cloud.deploy.d/bootstrap_salt.sh:
    file:
      - source: salt://salt/ci/bootstrap.jinja2

{%- for script in ('import_test_data.py', 'retcode_check.py') %}
/usr/local/bin/{{ script }}:
  file:
    - managed
    - source: salt://salt/ci/{{ script }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local
{%- endfor %}

/etc/salt/master.d/ci.conf:
  file:
    - managed
    - source: salt://salt/ci/master.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: salt-master
    - watch_in:
      - service: salt-master

/etc/sudoers.d/jenkins:
  file:
    - managed
    - source: salt://salt/ci/sudo.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/var/lib/jenkins/salt-test.sh:
  file:
    - managed
    - user: jenkins
    - group: nogroup
    - mode: 500
    - source: salt://salt/ci/test.jinja2
    - template: jinja
    - require:
      - pkg: jenkins

/etc/cron.d/salt-archive-ci:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://salt/ci/cron.jinja2
    - require:
      - pkg: rsync
      - user: salt_archive

/srv/salt/jenkins_archives:
  file:
    - directory
    - user: jenkins
    - group: root
    - mode: 750
    - require:
      - pkg: jenkins
      - file: /srv/salt
