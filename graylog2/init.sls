{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>

State(s) common to graylog2 web and server.
-#}
{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') %}

graylog2:
  user:
    - present
    - name: {{ user }}
    - home: /var/run/{{ user }}
    - shell: /bin/false

/var/run/graylog2:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - makedirs: True
    - require:
      - user: graylog2
