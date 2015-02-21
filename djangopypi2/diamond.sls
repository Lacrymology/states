{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('djangopypi2') %}
- memcache.diamond
- postgresql.server.diamond
- rsyslog.diamond
- statsd.diamond
{%- endcall %}
