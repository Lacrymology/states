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

A testing job must be created with the following:

**Execute concurrent builds if necessary** turned on.

Select ``Multi SCM`` as **Source Code Management**. You need 3 repositories:

- Common states
- Non-common states
- Pillars repo

In each instance of Multi SCM, click 2nd ``Advanced...`` button and set the
**Local subdirectory for repo (optional)** to ``common``, ``non-common`` or
``pillar``.

Specify the tested branch, never put ``**`` or a single click on **build**
can trigger 200 builds.
