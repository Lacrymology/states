{%- macro passive_check(state) %}
/etc/nagios/nsca.d/{{ state }}.yml:
  file:
    - managed
    - makedirs: True
    - user: nagios
    - group: nagios
    - mode: 440
    - template: jinja
{%- if state == 'nrpe' %}
    - source: salt://nrpe/config.jinja2
{%- else %}
    - source: salt://{{ state|replace('.', '/') }}/nrpe/config.jinja2
{%- endif %}
    - require:
      - file: /etc/nagios/nsca.d
{%- if caller is defined %}
{%- for line in caller().split("\n") %}
{{ line|trim|indent(6, indentfirst=True) }}
{%- endfor %}
{%- endif %}
    - watch_in:
      - service: nsca_passive

/etc/cron.d/passive-checks-{{ state }}:
  file:
    - absent
    - watch_in:
      - service: cron

{{ state }}-monitoring:
  monitoring:
    - managed
    - name: {{ state }}
{%- if state == 'nrpe' %}
    - source: salt://nrpe/config.jinja2
{%- else %}
    - source: salt://{{ state|replace('.', '/') }}/nrpe/config.jinja2
{%- endif %}
    - require:
      - pkg: nagios-nrpe-server
{%- if caller is defined %}
{%- for line in caller().split("\n") %}
{{ line|trim|indent(6, indentfirst=True) }}
{%- endfor %}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server
{%- endmacro -%}
