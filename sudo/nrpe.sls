{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt.nrpe
{%- if salt['pillar.get']('sentry_dsn', False) %}
  - raven.mail.nrpe
{%- else %}
  - ssmtp.nrpe
{%- endif %}
