{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
openssh-client:
  file:
    - absent
    - name: /etc/ssh/ssh_config
{#- this cannot be purged because it is required to run another absent state.
    (ssh-keygen for backup.client.scp.absent)
    - require:
      - pkg: openssh-client
  pkg:
    - purged
#}

{{ salt['user.info']('root')['home'] }}/.ssh:
  file:
    - absent

/etc/ssh/keys:
  file:
    - absent

/etc/ssh/ssh_known_hosts:
  file:
    - absent
