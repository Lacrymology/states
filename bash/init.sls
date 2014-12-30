{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - local
  - locale

bash:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
      - cmd: system_locale
  file:
    - managed
    - name: /etc/profile.d/bash_prompt.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 555
    - source: salt://bash/config.jinja2
    - require:
      - pkg: bash
      - file: /usr/local/share/salt_common.sh

{{ salt['user.info']('root')['home'] }}/.bashrc:
  file:
    - absent

/usr/local/share/salt_common.sh:
  pkg:
    - installed
    - pkgs:
      - bsdutils {#- for /usr/bin/logger #}
      - util-linux {#- for /usr/bin/flock #}
    - require:
      - cmd: apt_sources
  file:
    - managed
    - template: jinja
    - source: salt://bash/salt-common.jinja2
    - require:
      - file: /usr/local/share
      - pkg: /usr/local/share/salt_common.sh
      - pkg: bash
