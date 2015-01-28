Troubleshoot
============

:doc:`/gitlab/doc/index` needs to be installed on at least 2GB RAM machine,
it uses up to 1GB from the beginning.

:doc:`/gitlab/doc/index` 7.3.2 is known to have memory leak problem.
The web application may have weird
behaviors such as does not update ``Merge Request`` or does not merge
``Merge Request`` when the free memory in that machine is low (~ 250 MB).
Sysadmin needs to manually restart service to workaround this problem.
(SSH into machine then run ``restart gitlab``).
