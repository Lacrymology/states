{#- Usage of this is governed by a license that can be found in doc/license.rst

As this file just include other, no need to absent it.
-#}

include:
  - bash.nrpe
  - cron.nrpe
  - jenkins.nrpe
  - pysc.nrpe
  - salt.cloud.nrpe
  - salt.master.nrpe
  - ssh.client.nrpe
  - sudo.nrpe
  - virtualenv.nrpe

extend:
  {#- if used in conjunction with salt.ci just used a slightly different
    config.jinja2 #}
  nsca-salt.master:
    file:
      - source: salt://salt/ci/nrpe/config.jinja2
  salt.master-monitoring:
    monitoring:
      - source: salt://salt/ci/nrpe/config.jinja2
  salt_mine_collect_minions_data:
    file:
      - absent

{#- workaround for include sls bug #}
salt_ci_dummy:
  cmd:
    - wait
    - name: 'true'
