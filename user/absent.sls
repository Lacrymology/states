{%- set users = salt["pillar.get"]("user", {}) %}
{%- for user in users %}
user_{{ user }}:
  user:
    - absent
    - name: {{ user }}
    - purge: True
    - force: True
{%- endfor %}

{%- for filename in ('passwd', 'group', 'shadow') %}
/etc/{{ filename }}.org:
  file:
    - absent
{%- endfor -%}
