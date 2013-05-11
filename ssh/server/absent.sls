{#
 Uninstall an OpenSSH secure shell server
 #}
openssh-server:
  pkg:
    - purged
    - require:
      - service: openssh-server
  file:
    - absent
    - name: /etc/ssh/sshd_config
    - require:
      - pkg: openssh-server
  service:
    - dead
    - enable: False
    - name: ssh

{{ salt['user.info']('root')['home'] }}/.ssh/authorized_keys:
  file:
    - absent
