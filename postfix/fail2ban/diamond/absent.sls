{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip_absent with context %}
{{ fail2ban_count_ip_absent('postfix') }}
