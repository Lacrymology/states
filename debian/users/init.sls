{#- Usage of this is governed by a license that can be found in doc/license.rst

Change shell of predefined user (UID <= 99) from `/bin/sh` to `/usr/sbin/nologin`
-#}

include:
  - apt

base-passwd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  cmd:
    - wait
    - name: update-passwd
    - watch:
      - file: /usr/share/base-passwd/passwd.master

/usr/share/base-passwd/passwd.master:
  file:
    - managed
    - source: salt://debian/users/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: base-passwd
