{#
 Uninstall Nagios NRPE Agent
#}
{{ opts['cachedir'] }}/nagiosplugin-requirements.txt:
  file:
    - absent

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

/usr/local/nagios:
  file:
    - absent

/usr/local/bin/check_memory.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_memory.py:
  file:
    - absent
