{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - locale
  - mail

amavis:
  pkg:
    - latest
    - name: amavisd-new
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
      - cmd: system_locale
  user:
    - present
    - shell: /usr/sbin/nologin
    - require:
      - pkg: amavis
