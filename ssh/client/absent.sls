{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{#- first state to be run, it needs to specify the order to setting
    order correctly if other absent needs to be run before/after all states in this SLS #}
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
    - require:
      - file: openssh-client
    - require_in:
      - file: /etc/ssh/keys

/etc/ssh/ssh_known_hosts:
  file:
    - absent
    - require:
      - file: openssh-client
    - require_in:
      - file: /etc/ssh/keys

/etc/ssh/ssh_known_hosts.old:
  file:
    - absent
    - require:
      - file: openssh-client
    - require_in:
      - file: /etc/ssh/keys

{#- latest state to be run #}
/etc/ssh/keys:
  file:
    - absent
