{#
 Remove carbon
 #}
/etc/logrotate.d/carbon:
  file:
    - absent

/var/log/graphite/carbon:
  file:
    - absent

/etc/graphite/storage-schemas.conf:
  file:
    - absent

/etc/graphite/carbon.conf:
  file:
    - absent

{% for instance in salt['pillar.get']('graphite:carbon:instances', []) %}
carbon-{{ instance }}:
  file:
    - absent
    - name: /etc/init.d/carbon-{{ instance }}
    - require:
      - service: carbon-{{ instance }}
  service:
    - dead
    - enable: False
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: /usr/local/graphite/bin/python /usr/local/graphite/bin/carbon-cache.py --config=/etc/graphite/carbon.conf --instance={{ instance }} start

carbon-{{ instance }}-logdir:
  file:
    - absent
    - name: /var/log/graphite/carbon/carbon-cache-{{ instance }}
    - require:
      - service: carbon-{{ instance }}
{% endfor %}
