{#
 Install TMPReaper that cleanup /tmp for left over files.
 #}
include:
  - cron

tmpreaper:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/tmpreaper.conf
    - source: salt://tmpreaper/config.jinja2
    - template: jinja
    - mode: 444
    - user: root
    - group: root
    - require:
      - pkg: tmpreaper
      - pkg: cron
