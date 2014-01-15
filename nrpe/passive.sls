{%- macro passive_check(state, service) -%}
{%- set state_checks = salt['monitoring.discover_checks_passive'](state) -%}
*/{{ state_checks[service]['passive_interval'] }} * * * * nagios /usr/local/nagios/bin/passive_check.py {{ service }}
{%- endmacro %}
