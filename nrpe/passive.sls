{%- macro passive_check(state) -%}
/etc/nagios/nsca.d/{{ state }}.yml:
  file:
    - managed
    - makedirs: True
    - user: nagios
    - group: nagios
    - mode: 440
    - template: jinja
    - source: salt://{{ state|replace('.', '/') }}/nrpe/config.jinja2
    - require:
      - file: /etc/nagios/nsca.d
    - watch_in:
      - service: nsca_passive

/etc/cron.d/passive-checks-{{ state }}:
  file:
    - absent
    - watch_in:
      - service: cron
{%- endmacro %}
