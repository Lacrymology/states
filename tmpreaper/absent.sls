{#
 Uninstall TMPReaper that cleanup /tmp for left over files.
 #}
tmpreaper:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/tmpreaper.conf
    - require:
      - pkg: tmpreaper
