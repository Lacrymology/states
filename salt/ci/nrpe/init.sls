{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
            Viet Hung Nguyen <hvn@robotinfra.com>
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

{#- workaround for include sls bug #}
salt_ci_dummy:
  cmd:
    - wait
    - name: 'true'
