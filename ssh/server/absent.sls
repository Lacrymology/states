{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
    - name: ssh

{{ salt['user.info']('root')['home'] }}/.ssh/authorized_keys:
  file:
    - absent

/usr/local/bin/root-shell-wrapper:
  file:
    - absent

/etc/rsyslog.d/ssh.conf:
  file:
    - absent
