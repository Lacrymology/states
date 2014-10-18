{%- macro upstart_absent(service) %}
{{ service }}:
  service:
    - dead
    - enable: False
  file:
    - absent
    - name: /etc/init/{{ service }}.conf
    - require:
      - service: {{ service }}

/etc/rsyslog.d/{{ service }}-upstart.conf:
  file:
    - absent
    - require:
      - service: {{ service }}

/etc/init/{{ service }}.override:
  file:
    - absent

    {%- for log_file in salt['file.find']('/var/log/upstart/', name=service + '.log*', type='f') %}
{{ log_file }}:
  file:
    - absent
    - require:
      - service: {{ service }}
    {%- endfor -%}
{%- endmacro -%}
