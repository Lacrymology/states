{#
 Configure an OpenSSH client
 #}
include:
  - apt

{% set root_home = salt['user.info']('root')['home'] %}

{{ root_home }}/.ssh:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

bitbucket.org:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client

github.com:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - require:
      - file: {{ root_home }}/.ssh
      - pkg: openssh-client

openssh-client:
  file:
    - managed
    - name: /etc/ssh/ssh_config
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://ssh/client/config.jinja2
    - require:
      - pkg: openssh-client
  pkg:
    - latest
    - require:
      - cmd: apt_sources
{% if pillar['deployment_key_source']|default(False) %}
      - file: {{ root_home }}/.ssh/id_dsa

{{ root_home }}/.ssh/id_dsa:
  file:
    - managed
    - source: {{ pillar['deployment_key_source'] }}
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: {{ root_home }}/.ssh
{% endif %}
