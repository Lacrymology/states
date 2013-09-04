{#
  TODO: add SSL through nginx
#}

include:
  - apt
  - nginx
  - java.7.jdk
{% if pillar['jenkins']['web']['ssl']|default(False) %}
  - ssl
{% endif %}

jenkins:
  pkgrepo:
    - managed
    - name: deb http://pkg.jenkins-ci.org/debian binary/
    #TODO mirror
    - file: /etc/apt/sources.list.d/jenkins.list
    - key_url: http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkgrepo: jenkins
      - pkg: openjdk_jdk
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

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/jenkins.conf
{% if pillar['jenkins']['web']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['jenkins']['web']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['jenkins']['web']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['jenkins']['web']['ssl'] }}/ca.crt
{% endif %}
