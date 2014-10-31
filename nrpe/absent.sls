{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Uninstall Nagios NRPE Agent.
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
{% for dirname in ('/etc', '/var/run') %}
{{ dirname }}/nagios:
  file:
    - absent
    - require:
      - user: nagios
      - service: nsca_passive
{% endfor %}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('nsca_passive') }}

/usr/local/nagios/bin/nsca_passive:
  file:
    - absent

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

/usr/lib/nagios:
  file:
    - absent

{#- TODO: remove that statement in >= 2014-04 #}
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

/etc/cron.d/passive-checks-nrpe.cfg:
  file:
    - absent

/etc/nagios/nsca.conf:
  file:
    - absent

/etc/nagios/nsca.yaml:
  file:
    - absent

/etc/nagios/nsca.d:
  file:
    - absent

/var/run/nagios/passive_check.lock:
  file:
    - absent

/etc/rsyslog.d/nrpe.conf:
  file:
    - absent
