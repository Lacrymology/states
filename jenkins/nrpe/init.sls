{#
 Nagios NRPE check for jenkins
#}
include:
  - java.7.jdk
  - apt.nrpe
  - nginx.nrpe
{% if pillar['jenkins']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
/etc/nagios/nrpe.d/jenkins.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://jenkins/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/jenkins-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: jenkins
      domain_name: {{ salt['pillar.get']('jenkins:hostnames')[0] }}
{% if pillar['jenkins']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{% endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/jenkins.cfg
        - file: /etc/nagios/nrpe.d/jenkins-nginx.cfg
