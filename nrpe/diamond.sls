{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Diamond statistics for Nagios NRPE
-#}
include:
  - diamond
  - diamond.nrpe
  - rsyslog.diamond
  - nrpe.rsyslog.diamond
  - sudo.diamond

nrpe_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nrpe]]
        exe = ^\/usr\/sbin\/nrpe$
        cmdline = ^\/usr\/lib\/nagios\/plugins\/check_
        [[init]]
        exec = ^\/sbin\/init$
