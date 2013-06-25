{#
 Install a MongoDB NoSQL server.

 If one day MongoDB support SSL in free distribution, do this:
 http://docs.mongodb.org/manual/tutorial/configure-ssl/
 #}
include:
  - logrotate

{% set version = '2.4.4' %}
{% set filename = 'mongodb-10gen_' + version + '_' + grains['debian_arch'] + '.deb' %}

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
    - watch:
      - pkg: mongodb
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - mongodb-10gen: {{ pillar['files_archive'] }}/mirror/{{ filename }}
{%- else %}
      - mongodb-10gen: http://downloads-distro.mongodb.org/repo/ubuntu-upstart/dists/dist/10gen/binary-{{ grains['debian_arch'] }}/{{ filename }}
{%- endif %}

mongodb_old_apt_repo:
  file:
    - name: /etc/apt/sources.list.d/downloads-distro.mongodb.org-repo_ubuntu-upstart-dist.list
    - absent
