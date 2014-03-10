:Copyrights: Copyright (c) 2014, Hung Nguyen Viet

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Hung Nguyen Viet

Pillar
======

NEED TO DOC PILLAR

Mandatory
---------

Example::

    salt_master:
      gitfs_remotes:
        - git@git.robotinfra.com:dev/common.git
        - git@git.robotinfra.com:infra/states.git

salt_master:gitfs_remotes
~~~~~~~~~~~~~~~~~~~~~~~~~

Git fileserver backend configuration
When using the git fileserver backend at least one git remote needs to be
defined. The user running the salt master will need read access to the repo.

Copied from: https://github.com/saltstack/salt/blob/2014.1/conf/master#L385

Optional
--------

Example::

    salt_master:
      workers: 1
      pillar:
        branch: develop
        remote: git@git.robotinfra.com:dev/pillars.git

salt_master:pillar
~~~~~~~~~~~~~~~~~~

Specify a remote git repo for using as ext pillar.

Default: ``False``

``False`` means not use.

salt_master:pillar:branch
~~~~~~~~~~~~~~~~~~~~~~~~~

Git branch when checkout remote git repo.

salt_master:pillar:remote
~~~~~~~~~~~~~~~~~~~~~~~~~

Git path to use for remote git repo.

salt_master:workers
~~~~~~~~~~~~~~~~~~~

Numbers of workers.

Default: ``5``

salt_master:loop_interval
~~~~~~~~~~~~~~~~~~~~~~~~~

The loop_interval option controls the seconds for the master's maintinance
process check cycle. This process updates file server backends, cleans the
job cache and executes the scheduler.
Copied from:
https://github.com/saltstack/salt/blob/2014.1/conf/master#L80

Default: ``60``

salt_master:keep_jobs_hours
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set the number of hours to keep old job information in the job cache
Copied from:
https://github.com/saltstack/salt/blob/2014.1/conf/master#L73

Default: ``24``
