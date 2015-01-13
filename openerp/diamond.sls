{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}

{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('openerp') %}
- postgresql.server.diamond
- rsyslog.diamond
{%- endcall %}
{%- if salt['pillar.get']('openerp:company_db', False) %}
        [[openerp]]
        cmdline = openerp-cron.py$
{%- endif %}
