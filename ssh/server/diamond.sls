{#
 Diamond statistics for OpenSSH Server
#}
include:
  - diamond
  - rsyslog.diamond

ssh_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[sshd]]
        exe = ^\/usr\/sbin\/sshd,^\/usr\/lib\/sftp\-server
