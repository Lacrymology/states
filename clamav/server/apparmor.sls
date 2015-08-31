{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apparmor
  - clamav.server

{#- Aug 20 18:45:31 p kernel: [36102.269466] type=1400 audit(1440096331.264:89): apparmor="DENIED" operation="exec" parent=1491 profile="/usr/bin/freshclam" name="/bin/dash" pid=1492 comm="freshclam" requested_mask="x" denied_mask="x" fsuid=109 ouid=0 #}
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
      - file: freshclam_apparmor
    - require_in:
      - file: clamav-freshclam
