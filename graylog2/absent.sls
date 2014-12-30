{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
include:
  - graylog2.server.absent
  - graylog2.web.absent

{%- for file in ['/var/run/graylog2', '/var/lib/graylog2'] %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog2-server
      - service: graylog2-web
{%- endfor -%}
