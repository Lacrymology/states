{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('roundcube') %}
- firewall.diamond
- postgresql.server.diamond
- rsyslog.diamond
{%- endcall %}

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip with context %}
{{ fail2ban_count_ip('roundcube-auth') }}
