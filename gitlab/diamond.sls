{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import uwsgi_diamond with context %}
{%- call uwsgi_diamond('gitlab') %}
- postgresql.server.diamond
- redis.diamond
- rsyslog.diamond
- ssh.server.diamond
{%- endcall %}

gitlab_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[gitlab]]
        cmdline = ^sidekiq 2\.17\.0 gitlabhq
