=====================
Jenkins Configuration
=====================

First go in one of the hostname you specified at ``jenkins:web:hostnames``.

Things you **should** do
------------------------

- Restrict project naming.
- Set admin e-mail address.
- Create a user AND switch to Matrix based security to prevent anonymous user to
  have read-only access to Jenkins.
- Install https://wiki.jenkins-ci.org/display/JENKINS/Timestamper and turn it
  on to all jobs.

Things you **must** do
----------------------

- Raise number of executor to large value such as ``20``.
- Set Jenkins URL to first value of ``jenkins:web:hostnames``.
- Configure SMTP.
- Install https://wiki.jenkins-ci.org/display/JENKINS/Multiple+SCMs+Plugin
- Configure SSH private key for user jenkins

Jobs
----

Multi SCM
branch
3 repos
specify local checkout
