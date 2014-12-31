{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
            Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
{%- set ssl = salt['pillar.get']('jenkins:ssl', False) %}

include:
  - apt
  - cron
  - java.7.jdk
  - local
  - nginx
  - pysc
  - ssh.client
{% if ssl %}
  - ssl
{% endif %}

jenkins_dependencies:
  pkg:
    - installed
    - names:
      - daemon
      - psmisc

{%- call manage_pid('/var/run/jenkins/jenkins.pid', 'jenkins', 'nogroup', 'jenkins') %}
- pkg: jenkins
{%- endcall %}

/var/lib/jenkins/tmp:
  file:
    - directory
    - user: jenkins
    - group: nogroup
    - mode: 750
    - require:
      - pkg: jenkins

{%- set version = '1.545' %}
jenkins:
  pkg:
    - installed
    - sources:
{%- if salt['pillar.get']('files_archive', False) %}
      - jenkins: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/jenkins_{{ version }}_all.deb
{%- else %}
      - jenkins: http://pkg.jenkins-ci.org/debian/binary/jenkins_{{ version }}_all.deb
{%- endif %}
    - require:
      - cmd: apt_sources
      - pkg: jdk-7
      - pkg: jenkins_dependencies
  file:
    - managed
    - name: /etc/default/jenkins
    - source: salt://jenkins/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: jenkins
  service:
    - running
    - watch:
      - file: /var/lib/jenkins/tmp
      - file: jenkins
      - pkg: jre-7
      - file: jre-7

{%- if salt['pkg.version']('jenkins') not in ('', version) %}
jenkins_old_version:
  pkg:
    - removed
    - name: jenkins
    - require_in:
      - pkg: jenkins
{%- endif %}

/etc/nginx/conf.d/jenkins.conf:
  file:
    - managed
    - template: jinja
    - source: salt://jenkins/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - service: jenkins
    - watch_in:
      - service: nginx

/etc/cron.daily/jenkins_delete_old_workspaces.py:
  file:
    - absent

/etc/cron.daily/jenkins_delete_old_workspaces:
  file:
    - managed
    - source: salt://jenkins/del_old_ws.py
    - mode: 500
    - require:
      - file: /usr/local
      - service: jenkins
      - pkg: cron
      - module: pysc

{% if ssl %}
extend:
{%- from 'macros.jinja2' import change_ssh_key_owner with context %}
{{ change_ssh_key_owner('jenkins', {'pkg': 'jenkins'}) }}
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
