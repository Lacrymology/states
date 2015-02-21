{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('roundcube') %}
- postgresql.server.diamond
- rsyslog.diamond
{%- endcall %}
