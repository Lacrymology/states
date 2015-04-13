{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - ppp

xl2tpd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  module:
    - wait
    - name: service.stop
    - m_name: xl2tpd
    - watch:
      - pkg: xl2tpd
  cmd:
    - wait
    - name: update-rc.d -f xl2tpd remove
    - watch:
      - module: xl2tpd
  file:
    - absent
    - name: /etc/init.d/xl2tpd
    - watch:
      - cmd: xl2tpd
  service:
    - running
    - require:
      - file: xl2tpd
    - watch:
      - file: /etc/init/xl2tpd.conf
      - file: /etc/xl2tpd/xl2tpd.conf
      - file: /etc/xl2tpd/l2tp-secrets
      {#- requires specific pillar key, look in xl2tpd/doc/pillar.rst #}
      - file: ppp-options-xl2tpd

/etc/init/xl2tpd.conf:
  file:
    - managed
    - source: salt://xl2tpd/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: xl2tpd

/etc/xl2tpd/xl2tpd.conf:
  file:
    - managed
    - source: salt://xl2tpd/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: xl2tpd

/etc/xl2tpd/l2tp-secrets:
  file:
    - managed
    - contents: |
        {#- Let all, because we use auth with chap #}
        * * *
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: xl2tpd
