{#
 Uninstall an OpenSSH client
 #}
openssh-client:
  file:
    - absent
    - name: /etc/ssh/ssh_config
    - require:
      - pkg: openssh-client
  pkg:
    - purged

/root/.ssh/id_dsa:
  file:
    - absent

/root/.ssh/known_hosts:
  file:
    - absent
