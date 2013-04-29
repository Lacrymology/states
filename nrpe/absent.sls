{#
 Uninstall Nagios NRPE Agent
#}
nagiosplugin:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/nagiosplugin-requirements.txt

nagios-nrpe-server:
  pkg:
    - purged
    - names:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
    - require:
      - service: nagios-nrpe-server
  file:
    - absent
    - name: /etc/nagios
    - require:
      - pkg: nagios-nrpe-server
  service:
    - dead
    - enable: False

/usr/local/nagiosplugin:
  file:
    - absent

/usr/local/bin/check_memory.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_memory.py:
  file:
    - absent
