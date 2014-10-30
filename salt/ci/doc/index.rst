Salt Continous Integration Testing Server
=========================================

This is like a role, it's a mash-up of multiple low-level states to create a new
dedicated state to serve a single purpose.

Depencencies
------------

Salt Master
~~~~~~~~~~~

This is used to manage minions involved with CI tests. It's likely more than one
minions will constantly run. At least one for the CI server and it's
requirements.

But more permanent minions can run such as integration/qualification used to
test upgrades and allow human testers to log into them anytime.

But most minions will be temporary (created, run tests, then terminated).

Look in :doc:`/salt/master/doc/index` for more details.

Salt Archive
~~~~~~~~~~~~

As many minions will be created over time, we don't want the tests to run for
extra hours just to download files over public internet. that is costly and
ineffective. The salt archive is mandatory to have effective CI.
And that reduce the risks of test that failed because some public resource is
unavailable such as github.com.

To make sure that archive is up to date, the synchronization with upstream
salt archive server is executed each 5 minutes trough a cronjob.

Look in :doc:`/salt/archive/server/doc/index` for more details.

Salt Cloud
~~~~~~~~~~

Most CI jobs are tests that are triggered trough various reasons such as a
schedule or a git branch updated. Those will create a new minion to execute the
states of the tip of the branch at that exact moment.
Multiple tests (minions) can run in parallels, all on their own VMs.

When VM is created test suite is executed.

On test failure or completion, results are gathered and VM terminated.

Salt cloud is use to create those VMs, run bootstrap script and terminated
completion.

Look in :doc:`/salt/cloud/doc/index` for more details.

Jenkins
~~~~~~~

CI server is a web UI that allow users to create jobs that are triggered one
some conditions such as:

- A job is configured to run a git fetch at some specific frequency (5 minutes).
  If someone git push a branch, in max 5 minutes, CI server detect the change
  and then git pull and run the job.
- A private git repo come with hook that perform a call back to CI server notify
  that changes were pushed to that branch and job need to run.
- Github is configured to perform a callback to CI server when a push occurs.
- :doc:`/gitlab/doc/index` plugins:
  - `Gitlab merge request <https://wiki.jenkins-ci.org/display/JENKINS/Gitlab+Merge+Request+Builder+Plugin>`__
  - `Gitlab hook plugin <https://wiki.jenkins-ci.org/display/JENKINS/Gitlab+Hook+Plugin>`__
- A job is configured to run at specific time (such as each day at midnight)

The jobs can 2 different things:

Highstate
`````````

Run state.highstate on a specific set of minions, basically::

 salt -t 6000 'targetrule*' state.highstate test=True

 if that step don't fail:

 salt -t 6000 'targetrule*' state.highstate

Those minions pillars need to have their branch set to the same branch name
as the CI jobs is watched.

Installation
------------

As this formula depends on previously specified dependencies,

You have to go through each of them and configure pillar and follow their own
doc before doing this formula. But you can apply all the formulas
simultaneously with a single ``state.highstate`` if you have appropriate role.

Here are ``salt.ci`` specific consideration with those dependencies:

.. toctree::
    :glob:

    *
