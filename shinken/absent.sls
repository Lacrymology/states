{#
 Uninstall all Shinken components
 #}

{% set roles = ('broker', 'arbiter', 'reactionner', 'poller', 'scheduler') %}

{% for role in roles %}
/etc/init/shinken-{{ role }}.conf:
  file:
    - absent
    - require:
      - service: shinken-{{ role }}

shinken-{{ role }}:
  service:
    - dead
    - enable: False
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

/etc/nginx/conf.d/shinken-web.conf:
  file:
    - absent
