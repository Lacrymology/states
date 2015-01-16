{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('shinken-poller') }}

/etc/shinken/poller.conf:
  file:
    - absent
