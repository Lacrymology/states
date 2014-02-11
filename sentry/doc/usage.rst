Sentry
======

:copyrights: Copyright (c) 2013, Quan Tong Anh

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
:authors: - Quan Tong Anh

Initial deployment
------------------

Follow the instruction in the `master_installation.rst` and
`minion_installation.rst` to bootstrap Salt.

Sentry
------

From the Salt master, you can install `Sentry` on the target minion by
running::

  salt myminion state.sls sentry

Don't surprise if you see this command returns nothing because it may take a
few (ten) minutes to execute. Let's check all actively running jobs::

  salt-run jobs.active

you will see something like this::

  '20131212061915418364':
    Arguments:
    - sentry
    Function: state.sls
    Start Time: 2013, Dec 12 06:19:15.418364
    Target: q-alerts
    Target-type: glob
    User: root

then display the return data::
  
  salt-run jobs.lookup_jid 20131212061915418364

You can also see what's going on by checking the log on the minion::

  tail -f /var/log/salt/minion

Login to the web interface (`https://q-alerts.robotinfra.com`) with your Sentry account that is defined in the pillar.

Create a new project and start send logging to the Sentry follow `this <http://sentry.readthedocs.org/en/latest/client/index.html>`_ guide.
