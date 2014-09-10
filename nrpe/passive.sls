{%- macro passive_check(formula, domain_name=None, pillar_prefix=None, check_sslyze=True) -%}
    {%- if not pillar_prefix -%}
        {%- set pillar_prefix = formula -%}
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

/etc/cron.d/passive-checks-{{ formula|replace('.', '-') }}:
  file:
    - absent

{% if salt['pillar.get'](pillar_prefix ~ ':ssl', False) and check_sslyze %}
{#- manage cron file for sslyze NRPE check consumer #}
  {%- set domain_name = salt['pillar.get'](pillar_prefix + ':hostnames', ['127.0.0.1'])[0] if not domain_name -%}
  {% if domain_name|replace('.', '')|int == 0 %} {# only check if it is a domain, not IP. int returns 0 for unconvertible value #}
/etc/cron.d/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - managed
    - name: /etc/cron.d/sslyze_check_{{ formula|replace('.', '-') }}
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://sslyze/cron_template.jinja2
    - context:
      formula: {{ formula }}
    - require:
      - file: check_ssl_configuration.py
      - pkg: cron
      - file: /etc/nagios/nsca.d/{{ formula }}.yml

    {%- if formula|replace('.', '') != formula %}
/etc/cron.d/sslyze_check_{{ formula }}:
  file:
    - absent
    {%- endif %}

  {%- else %}
/etc/cron.d/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - absent
  {%- endif %}

{%- else %}
/etc/cron.d/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - absent
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

/etc/cron.d/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - absent
    - name: /etc/cron.d/sslyze_check_{{ formula|replace('.', '-') }}
{%- endmacro %}
