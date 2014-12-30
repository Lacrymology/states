{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('shinken-poller') }}

/etc/shinken/poller.conf:
  file:
    - absent
