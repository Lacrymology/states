{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
amavis:
  service:
    - dead
  pkg:
    - purged
    - name: amavisd-new
    - require:
      - service: amavis
  user:
    - absent
    - require:
      - pkg: amavis
      - service: amavis

{#
 For some reason, purge amavisd-new Ubuntu package don't clean these.
 /var/run/amavis is $HOME of user amavis.
 So, when amavisd-new is uninstalled the first time the UID of this
 directory is changed to something else, once userdel amavis is executed.
 When amavisd-new is installed again, it can't write the PID file in
 /var/run/amavis. As the ownership is not for itself, it can't write the PID.
 This cause stopping the service to fail, as it can't find a PID.
#}
{% for dirname in ('/etc', '/var/run', '/var/lib') %}
{{ dirname }}/amavis:
  file:
    - absent
    - require:
      - user: amavis
{% endfor %}

/etc/cron.daily/amavisd-new:
  file:
    - absent
