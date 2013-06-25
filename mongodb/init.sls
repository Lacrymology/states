{#
 Install a MongoDB NoSQL server.

 If one day MongoDB support SSL in free distribution, do this:
 http://docs.mongodb.org/manual/tutorial/configure-ssl/
 #}
include:
  - logrotate
  - apt


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
{%- if 'files_archive' not in pillar %}
  pkg:
    - installed
    - name: mongodb-10gen
    - require:
      - cmd: apt_sources
      - pkgrepo: mongodb
  pkgrepo:
    - managed
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - file: /etc/apt/sources.list.d/downloads-distro.mongodb.org-repo_ubuntu-upstart-dist.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
{%- else %}
  pkg:
    - installed
    - sources:
      {%- if grains['cpuarch'] == 'x86_64' %}
      - mongodb-10gen: {{ pillar['files_archive'] }}/mirror/mongodb-10gen_2.4.4_amd64.deb
      {%- else %}
      - mongodb-10gen: {{ pillar['files_archive'] }}/mirror/mongodb-10gen_2.4.4_i386.deb
      {%- endif %}

mongodb_old_apt_repo:
  file:
    - name: /etc/apt/sources.list.d/downloads-distro.mongodb.org-repo_ubuntu-upstart-dist.list
    - absent
{%- endif %}
