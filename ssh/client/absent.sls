{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall an OpenSSH client
 -#}
openssh-client:
  file:
    - absent
    - name: /etc/ssh/ssh_config
    - require:
      - pkg: openssh-client
  pkg:
    - purged

{% set root_home = salt['user.info']('root')['home'] %}
{{ root_home }}/.ssh/id_dsa:
  file:
    - absent

{{ root_home }}/.ssh/known_hosts:
  file:
    - absent
