{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
denyhosts:
  pkg:
    - purged
    - require:
      - service: denyhosts
  file:
    - absent
    - name: /etc/denyhosts.conf
    - require:
      - service: denyhosts
  service:
    - dead
    - enable: False

{% for file in ('/etc/hosts.deny', '/etc/logrotate.d/denyhosts', '/var/log/denyhosts', '/var/lib/denyhosts', '/usr/local/bin/denyhosts-unblock') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
