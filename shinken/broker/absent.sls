{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
