{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
{%- if salt['pillar.get']('sentry_dsn', False) %}
  - raven.mail
{%- else %}
  - raven.mail.absent
  - ssmtp
{%- endif %}
