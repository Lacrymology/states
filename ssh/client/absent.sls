{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

/etc/ssh/ssh_known_hosts.old:
  file:
    - absent
