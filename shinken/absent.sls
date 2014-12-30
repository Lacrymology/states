{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Uninstall all Shinken components.
-#}

{% set roles = ('broker', 'arbiter', 'reactionner', 'poller', 'scheduler', 'receiver') %}
include:
{% for role in roles %}
  - shinken.{{ role }}.absent
{% endfor %}

shinken:
  user:
    - absent
    - require:
{% for role in roles %}
      - service: shinken-{{ role }}
{% endfor %}

{% for rootdir in ('etc', 'usr/local', 'var/log', 'var/lib', 'var/run') %}
/{{ rootdir }}/shinken:
  file:
    - absent
    - require:
{% for role in roles %}
      - service: shinken-{{ role }}
{% endfor %}
{% endfor %}

/usr/local/bin/shinken-ctl.sh:
  file:
    - absent
