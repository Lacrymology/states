{#-
Copyright (c) 2013, Hung Nguyen Viet
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
