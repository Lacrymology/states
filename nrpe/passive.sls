{%- macro passive_check(formula, domain_name=None, pillar_prefix=None, check_ssl_score=False) -%}
    {%- if not pillar_prefix -%}
        {%- set pillar_prefix = formula -%}
    {%- endif %}

nsca-{{ formula }}:
  file:
    - managed
    - name: /etc/nagios/nsca.d/{{ formula }}.yml
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
{%- if caller is defined -%}
    {%- for line in caller().split("\n") %}
{{ line|trim|indent(6, indentfirst=True) }}
    {%- endfor -%}
{%- endif %}
    - watch_in:
      - service: nsca_passive
    - require_in:
{%- if salt['pillar.get'](pillar_prefix ~ ':ssl', False) and check_ssl_score %}
      - file: check_ssl_configuration.py
{%- endif %}
      - service: nagios-nrpe-server

/etc/cron.d/passive-checks-{{ formula|replace('.', '-') }}:
  file:
    - absent

{% if salt['pillar.get'](pillar_prefix ~ ':ssl', False) and check_ssl_score -%}
{#- manage cron file for sslyze NRPE check consumer -#}
  {%- set domain_name = salt['pillar.get'](pillar_prefix + ':hostnames', ['127.0.0.1'])[0] if not domain_name -%}
  {%- if domain_name|replace('.', '')|int == 0 -%}
    {#- only check if it is a domain, not IP. int returns 0 for unconvertible value #}
/etc/cron.twice_daily/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://sslyze/cron_template.jinja2
    - context:
      formula: {{ formula }}
    - require:
      - file: check_ssl_configuration.py
      - pkg: cron
      - file: nsca-{{ formula }}

    {%- if formula|replace('.', '') != formula %}
/etc/cron.twice_daily/sslyze_check_{{ formula }}:
  file:
    - absent
    {%- endif -%}

  {%- else %}
/etc/cron.twice_daily/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - absent
  {%- endif -%}

{%- else %}
/etc/cron.twice_daily/sslyze_check_{{ formula|replace('.', '-') }}:
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
{%- if caller is defined -%}
    {%- for line in caller().split("\n") %}
{{ line|trim|indent(6, indentfirst=True) }}
    {%- endfor -%}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server
{%- endmacro -%}

{%- macro passive_absent(formula) %}
/etc/nagios/nrpe.d/{{ formula }}.cfg:
  file:
    - absent

nsca-{{ formula }}:
  file:
    - absent
    - name: /etc/nagios/nsca.d/{{ formula }}.yml

/etc/cron.twice_daily/sslyze_check_{{ formula|replace('.', '-') }}:
  file:
    - absent
{%- endmacro %}
