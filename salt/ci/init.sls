{#-
Salt Continuous Integration (CI)
================================

This is like a role, it's a mash-up of multiple low-level states to create a new
dedicated state to serve a single purpose.

This state depends on:

Salt Master
-----------

This is used to manage minions involved with CI tests. It's likely more than one
minions will constantly run. At least one for the CI server and it's
requirements.

But more permanent minions can run such as integration/qualification used to
test upgrades and allow human testers to log into them anytime.

But most minions will be temporary (created, run tests, then terminated).

Salt Archive
------------

As many minions will be created over time, we don't want the tests to run for
extra hours just to download files over public internet. that is costly and
ineffective. The salt archive is mandatory to have effective CI.
And that reduce the risks of test that failed because some public resource is
unavailable such as github.com.

To make sure that archive is up to date, the synchronization with upstream
salt archive server is executed each 5 minutes trough a cronjob.

Salt Cloud
----------

Most CI jobs are tests that are triggered trough various reasons such as a
schedule or a git branch updated. Those will create a new minion to execute the
states of the tip of the branch at that exact moment.
Multiple tests (minions) can run in parallels, all on their own VMs.

When VM is created test suite is executed.

On test failure or completion, results are gathered and VM terminated.

Salt cloud is use to create those VMs, run bootstrap script and terminated
completion.

CI Server (Jenkins)
-------------------

CI server is a web UI that allow users to create jobs that are triggered one
some conditions such as:

- A job is configured to run a git fetch at some specific frequency (5 minutes).
  If someone git push a branch, in max 5 minutes, CI server detect the change
  and then git pull and run the job.
- A private git repo come with hook that perform a call back to CI server notify
  that changes were pushed to that branch and job need to run.
- Github is configured to perform a callback to CI server when a push occurs.
- Gitlab:
  - https://wiki.jenkins-ci.org/display/JENKINS/Gitlab+Merge+Request+Builder+Plugin
  - https://wiki.jenkins-ci.org/display/JENKINS/Gitlab+Hook+Plugin
- A job is configured to run at specific time (such as each day at midnight)

The jobs can 2 different things:

Highstate
~~~~~~~~~

Run state.highstate on a specific set of minions, basically::

 salt -t 6000 'targetrule*' state.highstate test=True

 if that step don't fail:

 salt -t 6000 'targetrule*' state.highstate

Those minions pillars need to have their branch set to the same branch name
as the CI jobs is watched.

Run test suite
~~~~~~~~~~~~~~

- CI job need git pull all states branches.
- Run bootstrap_archive.py and create a single artifact that will copied to the
  Minion by the bootstrap script.
- Run a CI specific bootstrap script (not the one that come with salt.cloud
  state. This alternate script copy the artifact and follow the testing
  framework steps::

  - chdir /
  - extract the artifact
  - install minion (like salt/cloud/bootstrap.jinja2)
  - run /root/salt/states/test/integration.py
-#}

include:
  - jenkins.git
  - rsync
  - salt.cloud
  - salt.archive
  - salt.master
  - ssh.client
  - sudo

extend:
  /etc/salt/cloud.deploy.d/bootstrap_salt.sh:
    file:
      - source: salt://salt/ci/bootstrap.jinja2

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
    - mode: 550
    - require:
      - pkg: jenkins
      - file: /srv/salt
