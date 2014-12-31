{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
            Quan Tong Anh <quanta@robotinfra.com>

Diamond statistics for amavis.
-#}

include:
  - amavis
  - diamond
  - cron.diamond
  - spamassassin.diamond

amavis_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[amavis]]
        name = ^amavisd

/etc/diamond/collectors/AmavisCollector.conf:
  file:
    - managed
    - source: salt://diamond/basic_collector.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/diamond/collectors
      - service: amavis
    - watch_in:
      - service: diamond
