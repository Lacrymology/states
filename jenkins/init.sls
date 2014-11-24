{#-
Copyright (c) 2013, Nicolas Plessis
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
            Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - cron
  - java.7.jdk
  - local
  - nginx
  - pysc
  - ssh.client
{% if salt['pillar.get']('jenkins:ssl', False) %}
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

{%- set version = '1.545' %}
jenkins:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - jenkins: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/jenkins_{{ version }}_all.deb
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

{% if salt['pillar.get']('jenkins:ssl', False) %}
extend:
{%- from 'macros.jinja2' import change_ssh_key_owner with context %}
{{ change_ssh_key_owner('jenkins', {'pkg': 'jenkins'}) }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ pillar['jenkins']['ssl'] }}
{% endif %}
