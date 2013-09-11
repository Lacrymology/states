{#
 Uninstall Nagios NRPE Agent
#}
{{ opts['cachedir'] }}/nagiosplugin-requirements.txt:
  file:
    - absent

nagios-nrpe-server:
  pkg:
    - purged
    - pkgs:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
    - require:
      - service: nagios-nrpe-server
  service:
    - dead
    - enable: False

{#
 For some reason, purge nagios-nrpe-server Ubuntu package don't clean these.
 /var/run/nagios is $HOME of user nagios.
 So, when nagios-nrpe-server is uninstalled the first time the UID of this
 directory is changed to something else, once userdel nagios is executed.
 When nagios-nrpe-server is installed again, it can't write the PID file in
 /var/run/nagios. As the ownership is not for itself, it can't write the PID.
 This cause stopping the service to fail, as it can't find a PID.
#}
{% for dirname in ('/etc', '/var/run') %}
{{ dirname }}/nagios:
  file:
    - absent
    - require:
      - user: nagios
{% endfor %}

nagios:
  user:
    - absent
    - require:
      - pkg: nagios-nrpe-server

/usr/lib/nagios/plugins:
  file:
    - absent
    - require:
      - pkg: nagios-nrpe-server

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

/usr/lib/nagios/plugins/check_oom.py:
  file:
    - absent

/etc/sudoers.d/nrpe_oom:
  file:
    - absent
