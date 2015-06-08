{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - cron.diamond
  - diamond
  - rsyslog.diamond

salt_master_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt-master-ProcessManager]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master ProcessManager$
        [[salt-master-clear-old-jobs]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master _clear_old_jobs$
        [[salt-master-Publisher]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master Publisher$
        [[salt-master-EventPublisher]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master EventPublisher$
        [[salt-master-ReqServer_ProcessManager]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master ReqServer_ProcessManager$
        [[salt-master-MWorker]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master MWorker$
        [[salt-master-MWorkerQueue]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master MWorkerQueue$
{%- if salt['pillar.get']('salt_master:reactor', False) %}
        [[salt-master-Reactor]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt-master Reactor$
{%- endif %}
