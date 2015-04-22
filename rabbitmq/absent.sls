{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

rabbitmq-server:
  pkg:
    - purged
    - require:
      - service: rabbitmq-server
  service:
    - dead
    - enable: False

/etc/rabbitmq:
  file:
    - absent
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: beam{% if grains['num_cpus'] > 1 %}.smp{% endif %}
    - require:
      - pkg: rabbitmq-server

rabbitmq:
  user:
    - absent
    - require:
      - service: rabbitmq-server
      - file: /etc/rabbitmq

{%- for log_file in ("shutdown", "startup") %}
/etc/rsyslog.d/rabbitmq-{{ log_file }}.conf:
  file:
    - absent
{%- endfor %}
