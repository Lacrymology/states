{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{%- set hostnames = salt["pillar.get"]("syncthing:hostnames", [])|default(False, boolean=True) %}
include:
  - syncthing
  - apt.nrpe
  - rsyslog.nrpe
{%- if salt['pillar.get']('syncthing:ssl', False) %}
  - ssl.nrpe
{%- endif %}
{%- if hostnames %}
  - nginx.nrpe
{%- endif %}

{%- if hostnames %}
  {{ passive_check('syncthing', check_ssl_score=True, domain_name=hostnames[0]) }}
{%- else %}
  {{ passive_check('syncthing') }}
{%- endif %}

extend:
  nagios-nrpe-server:
    user:
      - groups:
        - syncthing
      - require:
        - user: syncthing
