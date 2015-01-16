{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

            Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('graphite') %}
- memcache.diamond
- postgresql.server.diamond
- rsyslog.diamond
- statsd.diamond
{%- endcall %}
