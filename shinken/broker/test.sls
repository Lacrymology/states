include:
  - shinken.broker
  - shinken.broker.diamond
  - shinken.broker.nrpe

{%- set check_set = (('shinken_broker_web', 'Connection refused'),
                    ('shinken_broker_http', 'Connection refused'),
                    ('shinken_nginx_http', 'Invalid HTTP response'),
                    ('shinken_nginx_https', 'Invalid HTTP response')) %}

test:
  nrpe:
    - run_all_checks
    - exclude:
  {%- for name, _ in check_set %}
      - {{ name }}
  {%- endfor %}
    - require:
{% for name, failure in check_set %}
      - nrpe: {{ name }}
{%- endfor %}

{% for name, failure in check_set %}
{{ name }}:
  nrpe:
    - run_check
    - order: last
    - accepted_failure: {{ failure }}
{%- endfor %}
