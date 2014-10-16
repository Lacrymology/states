include:
{%- if salt['pillar.get']('sentry_dsn', False) %}
  - raven.mail
{%- else %}
  - raven.mail.absent
  - ssmtp
{%- endif %}
