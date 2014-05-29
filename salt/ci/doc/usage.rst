Usage
=====

.. TODO: FIX

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
