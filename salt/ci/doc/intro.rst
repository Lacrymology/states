Salt Continuous Integration (CI)
================================

:copyrights: Copyright (c) 2013, Hung Nguyen Viet
             All rights reserved.

             Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: 

             1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
             2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. 

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
             ARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
             WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
             ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
:authors: - Hung Nguyen Viet
          - Bruno Clermont 

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
