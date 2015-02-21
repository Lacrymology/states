{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('openerp') %}
- postgresql.server.diamond
- rsyslog.diamond
{%- endcall %}
{%- if salt['pillar.get']('openerp:company_db', False) %}
        [[openerp]]
        cmdline = openerp-cron.py$
{%- endif %}
