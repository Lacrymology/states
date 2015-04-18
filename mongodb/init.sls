{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - hostname
  - locale
  - logrotate

{% set version = '2.4.9' %}
{% set filename = 'mongodb-10gen_' + version + '_' + grains['osarch'] + '.deb' %}

mongodb:
  file:
    - managed
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/logrotate.jinja2
    - require:
      - pkg: logrotate
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: mongodb
      - file: /etc/mongodb.conf
      - user: mongodb
  pkg:
    - installed
    - require:
      - cmd: system_locale
      - host: hostname
    - sources:
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
      - mongodb-10gen: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
{%- else %}
      - mongodb-10gen: http://downloads-distro.mongodb.org/repo/ubuntu-upstart/dists/dist/10gen/binary-{{ grains['osarch'] }}/{{ filename }}
{%- endif %}
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: mongodb

{#- does not use PID, no need to manage #}

{%- if salt['pkg.version']('mongodb-10gen') not in ('', version) %}
mongodb_old_version:
  pkg:
    - removed
    - name: mongodb
    - require_in:
      - pkg: mongodb
{%- endif %}

/etc/mongodb.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://mongodb/config.jinja2
    - require:
      - pkg: mongodb
