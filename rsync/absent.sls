{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('rsync') }}

extend:
  rsync:
    pkg:
      - purged
      - require:
        - service: rsync

/etc/rsyncd.conf:
  file:
    - absent
    - require:
      - pkg: rsync
      - service: rsync

/etc/xinetd.d/rsync:
  file:
    - absent
    - require:
      - pkg: rsync
