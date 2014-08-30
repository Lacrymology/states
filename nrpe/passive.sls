{%- macro passive_check(state, domain_name=None) %}
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

{% if salt['pillar.get'](state ~ ':ssl', False) %}
{#- manage cron file for sslyze NRPE check consumer #}
{%- set domain_name = salt['pillar.get'](state + ':hostnames', ['127.0.0.1'])[0] if not domain_name -%}
  {% if domain_name|replace('.', '')|int == 0 %} {# only check if it is a domain, not IP. int returns 0 for unconvertible value #}
sslyze_collect_data_for_{{ state }}:
  file:
    - managed
    - name: /etc/cron.d/sslyze_check_{{ state }}
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://sslyze/cron_template.jinja2
    - context:
      deployment: {{ state }}
    - require:
      - file: check_ssl_configuration.py
      - pkg: cron
    - watch_in:
      - service: cron
  {%- else %}
sslyze_collect_data_for_{{ state }}:
  file:
    - absent
    - name: /etc/cron.d/sslyze_check_{{ state }}
  {%- endif %}
{%- endif %}

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

{%- macro passive_absent(state) %}
/etc/nagios/nrpe.d/{{ state }}.cfg:
  file:
    - absent

/etc/nagios/nsca.d/{{ state }}.yml:
  file:
    - absent

sslyze_collect_data_for_{{ state }}:
  file:
    - absent
    - name: /etc/cron.d/sslyze_check_{{ state }}
{%- endmacro %}
