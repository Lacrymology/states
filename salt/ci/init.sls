{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Bruno Clermont patate@fastmail.cn
       Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
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
  salt-cloud-boostrap-script:
    file:
      - source: salt://salt/ci/bootstrap.jinja2

{%- for script in ('import_test_data', 'retcode_check', 'wait_minion_up') %}
/usr/local/bin/{{ script }}.py:
  file:
    - managed
    - source: salt://salt/ci/{{ script }}.py
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
    - absent

{%- for name in ('build', 'post') %}
/var/lib/jenkins/salt-{{ name }}.sh:
  file:
    - managed
    - user: jenkins
    - group: nogroup
    - mode: 500
    - source: salt://salt/ci/{{ name }}.jinja2
    - template: jinja
    - require:
      - pkg: jenkins
{%- endfor %}

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
