.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. TODO: FIX THAT

Jenkins Installation
====================

Follow the generic logic of pillar, apply formula and run checks, then perform
the followings.

First go in one of the hostname you specified at ``jenkins:hostnames``.

Things you **should** do
------------------------

- Enable security in ``Configure Global Security`` then create an user.
  After that, switch to Matrix based security to prevent anonymous user to
  have read-only access to Jenkins.
- Set admin e-mail address.
- Install https://wiki.jenkins-ci.org/display/JENKINS/Timestamper and turn it
  on to all jobs.
- Set ``[a-zA-Z0-9\-]*`` as regular expression for job name. As job name are
  used to create VM hostname, this need to be a valid hostname.
- Raise number of executor to large value such as ``20``.
- Set Jenkins URL to first value of ``jenkins:hostnames``.
- Configure SMTP to send email for build status change.
