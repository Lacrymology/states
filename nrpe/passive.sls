{%- macro passive_check(formula, domain_name=None, pillar_prefix=None) -%}
    {%- if not pillar_prefix -%}
        {%- set pillar_prefix = deployment -%}
    {%- endif %}

/etc/nagios/nsca.d/{{ formula }}.yml:
  file:
    - managed
    - makedirs: True
    - user: nagios
    - group: nagios
    - mode: 440
    - template: jinja
{%- if formula == 'nrpe' %}
    - source: salt://nrpe/config.jinja2
{%- else %}
    - source: salt://{{ formula|replace('.', '/') }}/nrpe/config.jinja2
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

/etc/cron.d/passive-checks-{{ formula }}:
  file:
    - absent
    - watch_in:
      - service: cron

{% if salt['pillar.get'](pillar_prefix ~ ':ssl', False) %}
{#- manage cron file for sslyze NRPE check consumer #}
{%- set domain_name = salt['pillar.get'](pillar_prefix + ':hostnames', ['127.0.0.1'])[0] if not domain_name -%}
  {% if domain_name|replace('.', '')|int == 0 %} {# only check if it is a domain, not IP. int returns 0 for unconvertible value #}
sslyze_collect_data_for_{{ formula }}:
  file:
    - managed
    - name: /etc/cron.d/sslyze_check_{{ formula }}
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://sslyze/cron_template.jinja2
    - context:
      deployment: {{ formula }}
    - require:
      - file: check_ssl_configuration.py
      - pkg: cron
      - file: /etc/nagios/nsca.d/{{ formula }}.yml
    - watch_in:
      - service: cron
  {%- else %}
sslyze_collect_data_for_{{ formula }}:
  file:
    - absent
    - name: /etc/cron.d/sslyze_check_{{ formula }}
  {%- endif %}
{%- endif %}

{{ formula }}-monitoring:
  monitoring:
    - managed
    - name: {{ formula }}
{%- if formula == 'nrpe' %}
    - source: salt://nrpe/config.jinja2
{%- else %}
    - source: salt://{{ formula|replace('.', '/') }}/nrpe/config.jinja2
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

{%- macro passive_absent(formula) %}
/etc/nagios/nrpe.d/{{ formula }}.cfg:
  file:
    - absent

/etc/nagios/nsca.d/{{ formula }}.yml:
  file:
    - absent

sslyze_collect_data_for_{{ formula }}:
  file:
    - absent
    - name: /etc/cron.d/sslyze_check_{{ formula }}
{%- endmacro %}
