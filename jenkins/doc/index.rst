..
   Author: Nicolas Plessis <niplessis@gmail.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Jenkins
=======

Introduction
------------

Jenkins is an award-winning application that monitors executions of repeated
jobs, such as building a software project or jobs run by cron. Among those things,
current Jenkins focuses on the following two jobs:

* Building/testing software projects continuously, just like CruiseControl or DamageControl.
  In a nutshell, Jenkins provides an easy-to-use so-called continuous integration
  system, making it easier for developers to integrate changes to the project, and
  making it easier for users to obtain a fresh build. The automated, continuous build
  increases the productivity.
* Monitoring executions of externally-run jobs, such as cron jobs and procmail
  jobs, even those that are run on a remote machine. For example, with cron, all
  you receive is regular e-mails that capture the output, and it is up to you to
  look at them diligently and notice when it broke. Jenkins keeps those outputs
  and makes it easy for you to notice when something is wrong.

.. http://jenkins-ci.org/

Links
-----

* `Jenkins Homepage <http://jenkins-ci.org/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Jenkins_(software)>`_
* `Github <https://github.com/jenkinsci>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/cron/doc/index`
* :doc:`/nginx/doc/index`
* :doc:`/ssh/client/doc/index`
* :doc:`/ssl/doc/index`

Content
-------

.. toctree::
    :glob:

    *
