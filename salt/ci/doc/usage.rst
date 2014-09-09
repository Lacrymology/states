Usage
=====

.. TODO: FIX

Plugins
-------

Install following plugins:

- Execute shell task in ``Post-build actions``: postbuildscript (https://wiki.jenkins-ci.org/display/JENKINS/PostBuildScript+Plugin)
- Checkout source code with git: git (https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin)
- Use multiple SCMs: multiple-scms (https://wiki.jenkins-ci.org/display/JENKINS/Multiple+SCMs+Plugin)

Configuration
-------------

- Configure :doc:`/ssh/doc/index` private key
  for user ``jenkins`` throught Jenkins Web UI. (Dashboard => Credential
  => Add credential => Kind: :doc:`/ssh/doc/index` username with private key)

Jobs
----

A testing job should be created with the following:

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

In Build section, add a build step by choosing
``Add build step`` > ``Execute shell``::

    $WORKSPACE/common/test/jenkins/build.sh vim

which will run build script from path
``$WORKSPACE/common/test/jenkins/build.sh`` with one argument ``vim``,
this make build job run all test against ``vim`` formula.
To add more tests, just pass them as arguments to this script (separate
by space). To run all test, provide no argument.
