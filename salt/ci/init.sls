{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - cron
  - jenkins
  - jenkins.git
  - local
  - pysc
  - salt.cloud
  - salt.master
  - ssh.client
  - sudo
  - virtualenv

{%- for script in ('import_test_data', ) %}
/usr/local/bin/{{ script }}.py:
  file:
    - managed
    - source: salt://salt/ci/{{ script }}.py
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local
      - module: pysc
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

/srv/salt/jenkins_archives:
  file:
    - directory
    - user: jenkins
    - group: root
    - mode: 750
    - require:
      - pkg: jenkins
      - file: /srv/salt

/srv/salt/top/jenkins_archives:
  file:
    - symlink
    - target: /srv/salt/jenkins_archives
    - require:
      - pkg: jenkins
      - file: /srv/salt/jenkins_archives
      - file: /srv/salt/top/top.sls

ci-agent:
  user:
    - present
  file:
    - name: /home/ci-agent/.ssh
    - directory
    - user: ci-agent
    - group: ci-agent
    - mode: 750
    - require:
      - user: ci-agent

/home/ci-agent/.ssh/authorized_keys:
  file:
    - managed
    - user: ci-agent
    - group: ci-agent
    - mode: 400
    - contents: |
        {{ salt['pillar.get']('salt_ci:agent_pubkey')|indent(8) }}
    - require:
      - file: ci-agent

/etc/cron.daily/ci-agent-cleanup-build-logs:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - source: salt://salt/ci/cron.jinja2
    - template: jinja
    - require:
      - pkg: cron
      - user: ci-agent
      - file: bash

/etc/cron.daily/salt-ci-cleanup-archive:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - source: salt://salt/ci/cron_jenkins_archive.jinja2
    - template: jinja
    - require:
      - pkg: cron
      - file: bash

extend:
{#- minions managed by salt-master on CI server does not need highstate daily #}
  salt_master_cron_highstate:
    file:
      - absent
