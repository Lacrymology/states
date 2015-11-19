{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context %}
{%- set ssl = salt['pillar.get']('jenkins:ssl', False) %}
{%- set job_cleaner = salt['pillar.get']('jenkins:job_cleaner', False) %}

include:
  - apt
  - cron
  - java.7.jdk
  - local
  - nginx
  - pysc
  - ssh.client
{%- if job_cleaner %}
  - requests
{%- endif %}
{% if ssl %}
  - ssl
{% endif %}

jenkins_dependencies:
  pkg:
    - installed
    - pkgs:
      - daemon
      - psmisc

{%- call manage_pid('/var/run/jenkins/jenkins.pid', 'jenkins', 'jenkins', 'jenkins') %}
- pkg: jenkins
{%- endcall %}

/var/lib/jenkins/tmp:
  file:
    - directory
    - user: jenkins
    - group: jenkins
    - mode: 750
    - require:
      - pkg: jenkins

{#- ``go get`` does not support using ssh, this config git to do that,
    thus allow using ``go get`` with private repositories. #}
jenkins_git_config_allow_use_git_through_ssh_instead_of_https:
  file:
    - managed
    - name: /var/lib/jenkins/.gitconfig
    - source: salt://jenkins/gitconfig.jinja2
    - template: jinja
    - require:
      - pkg: git
      - pkg: jenkins
      - file: openssh-client
    - require_in:
      - service: jenkins

{%- set version = '1.618' %}
jenkins:
  pkg:
    - installed
    - sources:
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
      - jenkins: {{ files_archive|replace('file://', '')|replace('https://', 'http://') }}/mirror/jenkins_{{ version }}_all.deb
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
  user:
    - present
    - name: jenkins
    - groups:
      - jenkins
    - require:
      - pkg: jenkins
  service:
    - running
    - watch:
      - file: /var/lib/jenkins/tmp
      - file: jenkins
      - user: jenkins
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
    - user: root
    - group: www-data
    - mode: 440
    - context:
        appname: jenkins
        root: /var/cache/jenkins/war/
    - require:
      - pkg: nginx
      - service: jenkins
    - watch_in:
      - service: nginx

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

{%- if job_cleaner %}
/etc/cron.daily/jenkins_delete_old_jobs:
  file:
    - managed
    - source: salt://jenkins/del_old_job.py
    - mode: 500
    - user: root
    - group: root
    - require:
      - service: jenkins
      - pkg: cron
      - module: requests
      - module: pysc
      - file: /etc/jenkins/old_jobs.yml

/etc/jenkins:
  file:
    - directory
    - mode: 500
    - user: root
    - group: root
    - require:
      - pkg: jenkins

/etc/jenkins/old_jobs.yml:
  file:
    - managed
    - template: jinja
    - source: salt://jenkins/del_old_job_config.jinja2
    - mode: 500
    - user: root
    - group: root
    - context:
        username: {{ salt['pillar.get']('jenkins:job_cleaner:username') }}
        token: {{ salt['pillar.get']('jenkins:job_cleaner:token') }}
        url: {% if salt['pillar.get']('jenkins:ssl', False) %}https{%- else %}http{%- endif %}://{{ salt['pillar.get']('jenkins:hostnames')[0] }}
        days: {{ salt['pillar.get']('jenkins:job_cleaner:days_to_del', 15) }}
    - require:
      - file: /etc/jenkins

{%- else %}
/etc/cron.daily/jenkins_delete_old_jobs:
  file:
    - absent

/etc/jenkins:
  file:
    - absent

/etc/jenkins/old_jobs.yml:
  file:
    - absent
{%- endif %}

extend:
{%- from 'macros.jinja2' import change_ssh_key_owner with context %}
{{ change_ssh_key_owner('jenkins', {'pkg': 'jenkins'}) }}
{% if ssl %}
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
