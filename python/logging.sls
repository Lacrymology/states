{#-
 General use template of YAML data for Python logging
-#}
{%- macro logging(process_name, sentry_dsn_pillar_key) -%}
{%- set default_dsn = salt['pillar.get']('sentry_dsn', False) -%}
{%- set sentry_dsn = salt['pillar.get'](sentry_dsn_pillar_key, default_dsn) %}
logging:
  version: 1
  disable_existing_loggers: False
  formatters:
    only_message:
      format: '%(message)s'
    syslog:
      format: '{{ process_name }}[%(process)d]: %(message)s'
  handlers:
    syslog:
{%- if salt['pillar.get']('debug', False) %}
      level: DEBUG
{%- else %}
      level: INFO
{%- endif %}
      class: logging.handlers.SysLogHandler
      address: /dev/log
      facility: local7
      formatter: syslog
    console:
      level: ERROR
      class: logging.StreamHandler
      formatter: only_message
{%- if sentry_dsn %}
    sentry:
      level: WARNING
      class: raven.handlers.logging.SentryHandler
      dsn: {{ sentry_dsn }}
{%- endif %}
  loggers:
    '':
      level: DEBUG
      handlers:
        - syslog
        - console
{%- if sentry_dsn %}
        - sentry
{%- endif -%}
{%- endmacro -%}
