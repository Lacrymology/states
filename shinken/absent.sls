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
  file:
    - absent
    - name: /var/log/upstart/shinken-{{ role }}.log
    - require:
      - service: shinken-{{ role }}
{% endfor %}

shinken:
  user:
    - absent
    - require:
{% for role in roles %}
      - service: shinken-{{ role }}
{% endfor %}

nagios-nrpe-plugin:
  pkg:
    - purged

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
