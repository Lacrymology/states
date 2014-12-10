Common Repository Usage
=======================

Git Repositories
----------------

As explained in the introduction document, the **common** states repository
needs roles to work.

So, to use properly that states repository, at least 2 others git repository
need to be created.

The first one, is the git pillar repository. Why? You want to track changes in
your pillar files.

The 2nd repository is non-common states.

Where the repositories should be created? Wherever you want. It can be a public
git repository in github.com, a private git repository in bitbucket.org or a
private self-hosted repository into the same server as the salt master (there
is a git server state for that).

By default, git repositories are refreshed each 60 seconds. That means
a ``git fetch`` is executed on each git repositories each minute. If the git
servers are hosted on the same server as the salt master, the frequency can be
reduced a lot without performance penalty (or DoS github.com).

A good balance can be repositories on the salt master **and** an 2nd remote in
elsewhere for backup purpose.

Another good reason to have host git repositories in the salt master, is that
Salt don't support GitFS for pillars. Thus, a git-hook for push can be turned
on that will make pillars ``git pull``'ed each time new changes are pushed.

Unless another mechanism to trigger a git pull on the master is implemented,
such as a cronjob, the pillar need to be updated manually on the salt
master.

States
------

With a new state git repository, roles can be created.

But role can also refer to low-level states that aren't in **common** states
repository. Such as if a closed-source or commercial application depends on
a library or third party dependency, a ``somelib/init.sls`` and
``somelib/absent.sls`` can exists in the additional state repositories and be
include by the role.

:doc:`/ssl/doc/index` and :doc:`/ssh/doc/index` keys can be kept in that
repository too.

Multiple versions of states
---------------------------

But states can have multiple versions in separate branches. By default, it's the
master branch.

To specify which branch to use, the pillar data for a host need to contains the
branch key, such as::

  branch: develop

The only limitation with that, is that the branch name need to exist in all
git repositories (except the one for pillar).

Deployment
----------

Once pillar had been created to feed data to states and roles created, the next
step is to run tests. For that check tests document.

Once states are applied successfully, the salt master can bootstrap itself and
be available to configure all minions. For that, check the master installation
document.

Formula Installation
--------------------

.. TOOD
.. DOC HERE THE COMMON PRACTICE REGARDING FORMULA INSTALLATION
.. SUCH AS LOOKING AT PILLAR.RST
.. NRPE INTEGRATION SHOULD ALWAYS BE APPLIED TOO
.. AND USE monitoring.run_all_checks TO MAKE SURE THINGS ARE OK
