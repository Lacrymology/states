{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Remove Nagios NRPE check for Shinken arbiter.
-#}
/etc/nagios/nrpe.d/shinken-arbiter.cfg:
  file:
    - absent
