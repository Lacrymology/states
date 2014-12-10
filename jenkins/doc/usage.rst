Usage
=====

Follow the generic logic of pillar, apply formula and run checks, then perform
the followings.

First go in one of the hostname you specified at ``jenkins:hostnames``.

Things you **should** do
------------------------

- Enable security in ``Configure Global Security`` then create an user.
  After that, switch to Matrix based security to prevent anonymous user to
  have read-only access to Jenkins.
- Install https://wiki.jenkins-ci.org/display/JENKINS/Timestamper and turn it
  on to all jobs.
- Set ``[a-zA-Z0-9\-]*`` as regular expression for job name. As job name are
  used to create VM hostname, this need to be a valid hostname.
- Do following steps in ``Manage Jenkins``.
- Set ``System Admin e-mail address``.
- Raise number of executor (``# of executors``) to large value such as ``20``.
- Set ``Jenkins URL`` to first value of ``jenkins:hostnames``.
- Configure SMTP to send email for build status change.
