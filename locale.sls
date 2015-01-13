{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Set the locale for machine.
-#}
include:
  - apt
{% set encoding = salt['pillar.get']('encoding', 'en_US.UTF-8') %}

system_locale:
  pkg:
    - installed
    - name: language-pack-{{ encoding.split('_')[0] }}
    - require:
      - cmd: apt_sources
  debconf:
    - set
    - data:
        'locales/default_environment_locale': {'type': 'select', 'value': '{{ encoding }}'}
        'locales/locales_to_be_generated': {'type': 'multiselect', 'value': '{{ encoding }} {{ encoding }}'}
    - require:
      - pkg: system_locale
  locale:
    - system
    - name: {{ encoding }}
    - require:
      - pkg: system_locale
      - debconf: system_locale
  file:
    - managed
    - name: /etc/default/locale
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - contents: |
        LANG={{ encoding }}
        LC_ALL={{ encoding }}
        LC_CTYPE={{ encoding }}
    - require:
      - locale: system_locale
  cmd:
    - wait
    - name: locale-gen {{ encoding }}
    - watch:
      - locale: system_locale
      - file: system_locale
