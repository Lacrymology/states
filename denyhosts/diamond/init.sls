{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Diamond statistics for Denyhosts.
-#}
include:
  - diamond
  - rsyslog.diamond

denyhosts_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[denyhosts]]
        cmdline = ^python \/usr\/sbin\/denyhosts

/usr/local/diamond/share/diamond/user_scripts/count_denyhosts.sh:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://denyhosts/diamond/count_denyhosts.jinja2
    - require:
      - module: diamond
      - file: diamond.conf
