ejabberd:
  pkg:
{% if salt['pillar.get']('destructive_absent', False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - require:
      - service: ejabberd
  service:
    - dead

{%- for file in ('/var/lib/ejabberd', '/etc/ejabberd', '/var/log/ejabberd', '/usr/lib/ejabberd') %}
{{ file }}:
  file:
    - absent
    - name: {{ file }}
    - require:
      - pkg: ejabberd
{%- endfor %}

