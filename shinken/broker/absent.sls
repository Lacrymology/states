{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('shinken-broker') }}

/etc/nginx/conf.d/shinken-web.conf:
  file:
    - absent

/etc/shinken/broker.conf:
  file:
    - absent

/var/lib/shinken/webui.sqlite:
  file:
    - absent
