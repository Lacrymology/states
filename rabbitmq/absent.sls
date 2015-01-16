{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
