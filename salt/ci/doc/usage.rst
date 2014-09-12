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

Notices that some config options only available after installing all needed
plugins, so do install above plugins before doing followings steps.

- Configure SSH private key
  for user ``jenkins`` through Jenkins Web UI. (Dashboard => Credential
  => Add credential => ``Kind: SSH username with private key``)

Jobs
----

A testing job should be created with the following:

**Execute concurrent builds if necessary** turned on.

Select ``Multi SCM`` as **Source Code Management**. You need 2 git
repositories:

- Common states
- Pillars repo

In each instance of Multi SCM, at ``Additional Behaviours``, choose
``Check out to a sub-directory`` and set to ``common``, ``pillar``
respectively.

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

You may also want to adding following post-build actions:

- ``Archive the artifacts``
- ``Publish JUnit test result report``
- ``Execute a set of scripts`` and run
``$WORKSPACE/common/test/jenkins/post.sh`` script to delete created VM
- ``E-mail Notification`` to send email whenever a build fails.
