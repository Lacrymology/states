{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall all Shinken components
 -#}

{% set roles = ('broker', 'arbiter', 'reactionner', 'poller', 'scheduler') %}
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

{% for rootdir in ('etc', 'usr/local', 'var/log', 'var/lib') %}
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
