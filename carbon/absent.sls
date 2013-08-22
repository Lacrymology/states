{#
 Remove carbon
 #}
{%- set instances_count = pillar['graphite']['carbon']['instances'] %}

{% for instance in range(instances_count) %}
carbon-cache-{{ instance }}:
  file:
    - absent
    - name: /etc/init.d/carbon-cache-{{ instance }}
    - require:
      - service: carbon-cache-{{ instance }}
  service:
    - dead
    - enable: False
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: /usr/local/graphite/bin/python /usr/local/graphite/bin/carbon-cache.py --config=/etc/graphite/carbon.conf --instance={{ instance }} start
{% endfor %}

/usr/local/graphite/salt-carbon-requirements.txt:
  file:
    - absent

{%- set relay_instance = 'a' %}
carbon-relay-{{ relay_instance }}:
  file:
    - absent
    - name: /etc/init.d/carbon-relay-{{ relay_instance }}
    - require:
      - service: carbon-relay-{{ relay_instance }}
  service:
    - dead
    - enable: False
    - sig: /usr/local/graphite/bin/python /usr/local/graphite/bin/carbon-relay.py --config=/etc/graphite/carbon.conf --instance={{ relay_instance }} start

/etc/graphite/relay-rules.conf:
  file:
    - absent
    - require:
      - service: carbon-relay-{{ relay_instance }}

{% for file in ('/etc/logrotate.d/carbon', '/var/log/graphite/carbon', '/etc/graphite/storage-schemas.conf', '/etc/graphite/carbon.conf', '/var/lib/graphite/whisper') %}
{{ file }}:
  file:
    - absent
    - require:
  {% for instance in range(instances_count) %}
      - service: carbon-cache-{{ instance }}
  {% endfor %}
      - service: carbon-relay-{{ relay_instance }}
{% endfor %}
