{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - hostname
  - local
  - rsyslog

{%- set files_archive = salt['pillar.get']('files_archive', False)|default('http://archive.robotinfra.com', boolean=True) %}

{%- set tarball = 'statsdaemon-5c4dd1c9afc765130a1b66604de8bd1a27bb036f-linux-' ~ grains['osarch'] ~ '.tar.bz2' %}
{%- if grains['osarch'] == 'i386' %}
  {%- set tarball_md5="8803c6486659eeb3fd6b061eb64221b4" %}
{%- else %}
  {%- set tarball_md5="93e6b81d345c3fc2b8eb7ae8bd02e860" %}
{%- endif %}

{# origin source is from: https://github.com/bitly/statsdaemon/releases/ #}

/usr/local/statsd:
  file:
    - absent
    - require_in:
      - file: /usr/local/statsdaemon

{{ opts['cachedir'] }}/pip/statsd:
  file:
    - absent
    - require_in:
      - file: /usr/local/statsdaemon

/usr/local/statsdaemon:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local

/usr/local/statsdaemon/.source_hash.md5:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - contents: {{ tarball_md5 }}
    - require:
      - file: /usr/local/statsdaemon

statsdaemon_cleanup_old_versions:
  cmd:
    - wait
    - name: rm -rf /usr/local/statsdaemon/* {#- the source_hash file untouched as it has prefix ``.`` #}
    - watch:
      - file: /usr/local/statsdaemon/.source_hash.md5

statsdaemon_tarball:
  file:
    - managed
    - name: /usr/local/statsdaemon/{{ tarball }}
    - source: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ tarball }}
    - source_hash: md5={{ tarball_md5 }}
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: /usr/local/statsdaemon
      - cmd: statsdaemon_cleanup_old_versions

statsdaemon_chmod:
  file:
    - managed
    - name: /usr/local/statsdaemon/statsdaemon
    - mode: 755
    - user: root
    - group: root
    - require:
      - cmd: statsd

statsd:
  cmd:
    - wait
    - name: tar -xjvf {{ tarball }}
    - cwd: /usr/local/statsdaemon
    - watch:
      - cmd: statsdaemon_cleanup_old_versions
      - file: /usr/local/statsdaemon/.source_hash.md5
    - require:
      - file: statsdaemon_tarball
  file:
    - managed
    - name: /etc/init/statsd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://statsd/upstart.jinja2
  service:
    - running
    - enable: True
    - require:
      - host: hostname
      - service: rsyslog
    - watch:
      - file: statsd
      - cmd: statsd
      - file: statsdaemon_chmod
