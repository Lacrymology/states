{%- macro passive_check(state) -%}
    {#-
    This require the consumer of this macro to have included ``cron`` somewhere.
    But as long as it include ``nrpe`` it's ok as itself include ``cron``.
     -#}
    {%- set state_checks = salt['monitoring.discover_checks_passive'](state) -%}
    {%- if state_checks %}
/etc/cron.d/passive-checks-{{ state }}:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://nrpe/passive_cron.jinja2
    - require:
      - file: /etc/send_nsca.conf
      - pkg: cron
    - context:
      checks: {{ state_checks }}
    {%- endif -%}
{%- endmacro %}
