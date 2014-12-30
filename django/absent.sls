{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>

Remove Django specifics.
-#}
/usr/local/bin/check_robots.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_robots.py:
  file:
    - absent

/var/lib/nrpe:
  file:
    - absent
