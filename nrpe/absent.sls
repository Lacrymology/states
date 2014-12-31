{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{#- TODO: remove that statement in >= 2014-04 #}
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
  user:
    - absent
    - name: nagios
    - require:
      - pkg: nagios-nrpe-server
      - service: nsca_passive
  group:
    - absent
    - name: nagios
    - require:
      - user: nagios-nrpe-server
  file:
    - absent
    - name: /var/lib/nagios
    - require:
      - pkg: nagios-nrpe-server

{#
 For some reason, purge nagios-nrpe-server Ubuntu package don't clean these.
 /var/run/nagios is $HOME of user nagios.
 So, when nagios-nrpe-server is uninstalled the first time the UID of this
 directory is changed to something else, once userdel nagios is executed.
 When nagios-nrpe-server is installed again, it can't write the PID file in
 /var/run/nagios. As the ownership is not for itself, it can't write the PID.
 This cause stopping the service to fail, as it can't find a PID.
#}
{% for dirname in ('/etc', '/var/run', '/usr/lib', '/usr/local') %}
{{ dirname }}/nagios:
  file:
    - absent
    - require:
      - user: nagios
      - service: nsca_passive
      - pkg: nagios-nrpe-server
{% endfor %}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('nsca_passive') }}

/usr/local/nagiosplugin:
  file:
    - absent

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/bin/check_memory.py:
  file:
    - absent

/etc/sudoers.d/nrpe_oom:
  file:
    - absent

/etc/cron.d/passive-checks-nrpe.cfg:
  file:
    - absent

/etc/rsyslog.d/nrpe.conf:
  file:
    - absent
