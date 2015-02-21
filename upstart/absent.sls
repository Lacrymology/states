{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

{{ service }}-log:
  file:
    - absent
    - name: /var/log/upstart/{{ service }}.log
    - require:
      - service: {{ service }}

    {%- for log_file in salt['file.find']('/var/log/upstart/', name=service + '.log.*', type='f') %}
{{ log_file }}:
  file:
    - absent
    - require:
      - file: {{ service }}-log
    {%- endfor -%}
{%- endmacro -%}

{%- for log_file in salt['file.find']('/var/log/upstart/', name='network-interface-*', type='f') %}
{{ log_file }}:
  file:
    - absent
{%- endfor -%}
