{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

            Quan Tong Anh <quanta@robotinfra.com>

Diamond statistics for Sentry.
-#}
{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('sentry') %}
- memcache.diamond
- postgresql.server.diamond
- rsyslog.diamond
- statsd.diamond
{%- endcall %}
