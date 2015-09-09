{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'shinken/init.sls' import shinken_install_module with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - nginx
  - rsyslog
  - shinken
{% if ssl %}
  - ssl
{% endif %}
  - web

/etc/nginx/conf.d/shinken-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://shinken/broker/nginx.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web
    - watch_in:
      - service: nginx

{%- set graphite_address = salt['pillar.get']('graphite_address', False) %}
{%- if salt['pillar.get']('files_archive', False) -%}
    {%- if graphite_address -%}
        {%- call shinken_install_module('graphite') %}
- source_hash: md5=56b393c9970275327644123480ffd413
        {%- endcall %}
        {%- call shinken_install_module('ui-graphite') %}
- source_hash: md5=497dafa1036c84f2c5722fb557060c50
        {%- endcall %}
    {%- endif %}

    {%- call shinken_install_module('auth-cfg-password') %}
- source_hash: md5=c91aef6581d2d4ef33cccd50bd16faf4
    {%- endcall %}

    {%- call shinken_install_module('sqlitedb') %}
- source_hash: md5=ef0bc27efbcadc4f9056a263cd698cbd
    {%- endcall %}

    {%- call shinken_install_module('syslog-sink') %}
- source_hash: md5=41acd03bc4f0579debc6b0402d257a9a
    {%- endcall %}

    {%- call shinken_install_module('webui') %}
- source_hash: md5=396be5667ca41b57d65239d7bd4b061a
    {%- endcall %}
{%- else %}
    {%- if graphite_address -%}
        {{ shinken_install_module('graphite') }}
        {{ shinken_install_module('ui-graphite') }}
    {%- endif %}
    {%- for module_name in ('auth-cfg-password', 'sqlitedb', 'syslog-sink', 'webui') %}
{{ shinken_install_module(module_name) }}
    {%- endfor %}
{%- endif %}

shinken-broker:
  file:
    - managed
    - name: /etc/init/shinken-broker.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
        shinken_component: broker
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - file: /var/run/shinken
      - file: /var/lib/shinken
    - watch:
      - cmd: shinken
{%- if graphite_address %}
      - cmd: shinken-module-graphite
      - cmd: shinken-module-ui-graphite
{%- endif %}
{%- for module_name in ('auth-cfg-password', 'sqlitedb', 'syslog-sink', 'webui') %}
      - cmd: shinken-module-{{ module_name }}
{%- endfor %}
      - cmd: shinken-module-pickle-retention-file-generic
      - file: /etc/shinken/broker.conf
      - file: shinken
      - file: shinken-broker
      - service: rsyslog
      - user: shinken
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}

{% from 'upstart/rsyslog.jinja2' import manage_upstart_log with context %}
{{ manage_upstart_log('shinken-broker', severity="info") }}

/etc/shinken/broker.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
        shinken_component: broker
    - require:
      - file: /etc/shinken
      - user: shinken

{% if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
