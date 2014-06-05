{%- macro passive_check(state, extra_requirements) -%}
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
{%- for state, name in extra_requirements %}
      - {{ state }}: {{ name }}
{%- endfor -%}
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
    - name: wordpress
{%- for state, name in extra_requirements -%}
  {%- if loop.first %}
    - require:
  {%- endif -%}
      - {{ state }}: {{ name }}
{%- endfor -%}
{%- endmacro -%}
