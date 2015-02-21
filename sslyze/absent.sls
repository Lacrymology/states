{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set version = "0.9" -%}
{%- if grains['osarch'] == 'amd64' -%}
    {%- set bits = "64" -%}
{%- else -%}
    {%- set bits = "32" -%}
{%- endif -%}
{% for file in ('/usr/local/src/sslyze-' + version|replace(".", "_") + '-linux' + bits, '/usr/lib/nagios/plugins/check_ssl_configuration.py', '/usr/local/nagios/salt-sslyze-requirements.txt') %}
{{ file }}:
  file:
    - absent
{% endfor %}
