{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apparmor
  - clamav.server

{#- Aug 20 18:45:31 p kernel: [36102.269466] type=1400 audit(1440096331.264:89): apparmor="DENIED" operation="exec" parent=1491 profile="/usr/bin/freshclam" name="/bin/dash" pid=1492 comm="freshclam" requested_mask="x" denied_mask="x" fsuid=109 ouid=0 #}
/etc/apparmor.d/disable/usr.bin.freshclam:
  file:
    - absent

freshclam_apparmor:
  file:
    - append
    - name: /etc/apparmor.d/local/usr.bin.freshclam
    - text: |
        /bin/dash ix,
        /bin/touch ix,
    - require:
      - pkg: clamav-freshclam
  cmd:
    - wait
    - name: apparmor_parser -r /etc/apparmor.d/usr.bin.freshclam
    - require:
      - pkg: apparmor
    - watch:
      - file: /etc/apparmor.d/disable/usr.bin.freshclam
      - file: freshclam_apparmor
    - require_in:
      - file: clamav-freshclam

/etc/apparmor.d/disable/usr.sbin.clamd:
  file:
    - absent

{%- if salt['pillar.get']('clamav:mode', 'local') == "network" %}
{#- Sep  3 08:49:51 t kernel: [   10.661302] type=1400 audit(1441244991.306:23): apparmor="DENIED" operation="capable" profile="/usr/sbin/clamd" pid=1389 comm="clamd" capability=6  capname="setgid" #}
clamav_apparmor:
  file:
    - append
    - name: /etc/apparmor.d/local/usr.sbin.clamd
    - text: |
        capability setgid,
    - require:
      - pkg: clamav-daemon
  cmd:
    - wait
    - name: apparmor_parser -r /etc/apparmor.d/usr.sbin.clamd
    - require:
      - pkg: apparmor
    - watch:
      - file: clamav_apparmor
      - file: /etc/apparmor.d/disable/usr.sbin.clamd
    - require_in:
      - service: clamav-daemon
{%- endif -%}
