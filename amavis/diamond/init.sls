{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - amavis
  - cron.diamond
  - diamond
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
        cmdline = .*amavisd.+

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
