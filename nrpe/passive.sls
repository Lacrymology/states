{%- macro render_requirement(requirements=[]) %}
{#- requirements can be a dict or a list of dicts #}
{%- if requirements is mapping %}
{%- set requirements = [requirements] %}
{%- endif %}
  {%- for adict in requirements %}
    {%- for state, name in adict.iteritems() %}
      - {{ state }}: {{ name }}
    {%- endfor %}
  {%- endfor %}
{%- endmacro %}

{%- macro passive_check(state, extra_requirements=[]) %}
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
{{ render_requirement(extra_requirements) }}
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
{%- endif %}
    - require:
      - pkg: nagios-nrpe-server
{{ render_requirement(extra_requirements) }}
    - watch_in:
      - service: nagios-nrpe-server
{%- endmacro -%}
