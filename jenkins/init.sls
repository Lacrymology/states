{#-
 Author: Nicolas Plessis nicolas@microsigns.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
  TODO: add SSL through nginx
-#}

include:
  - apt
  - nginx
  - java.7.jdk
{% if pillar['jenkins']['ssl']|default(False) %}
  - ssl
{% endif %}

jenkins_dependencies:
  pkg:
    - installed
    - names:
      - daemon
      - psmisc

jenkins:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - jenkins: {{ pillar['files_archive']|replace('file://', '') }}/mirror/jenkins_1.529_all.deb
{%- else %}
      - jenkins: http://pkg.jenkins-ci.org/debian/binary/jenkins_1.529_all.deb
{%- endif %}
    - require:
      - cmd: apt_sources
      - pkg: openjdk_jdk
      - pkg: jenkins_dependencies
  service:
    - running
    - require:
      - pkg: jenkins

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

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/jenkins.conf
{% if pillar['jenkins']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['jenkins']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['jenkins']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['jenkins']['ssl'] }}/ca.crt
{% endif %}
