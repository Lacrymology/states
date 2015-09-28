{#- Usage of this is governed by a license that can be found in doc/license.rst #}

{%- from "btcd/map.jinja2" import btcd with context %}
include:
  - local
  - logrotate

/usr/local/btcd:
  file:
    - directory
    - user: root
    - group: btcd
    - mode: 550
    - require:
      - file: /usr/local
      - user: btcd

{{ btcd.install_dir }}:
  file:
    - directory
    - user: root
    - group: btcd
    - mode: 550
    - require:
      - file: /usr/local/btcd
      - user: btcd

btcd_cleanup_old_files:
  cmd:
    - wait
    - name: find /usr/local/btcd -maxdepth 1 -mindepth 1 -type d ! -name '{{ btcd.version }}' -exec rm -r '{}' \;
    - require:
      - service: btcd
    - watch:
      - file: {{ btcd.install_dir }}

{%- for dir in ("/var/lib/btcd", "/var/log/btcd") %}
{{ dir }}:
  file:
    - directory
    - user: btcd
    - group: btcd
    - mode: 750
    - require:
      - user: btcd
{%- endfor %}

/etc/btcd:
  file:
    - directory
    - user: root
    - group: btcd
    - mode: 750
    - require:
      - user: btcd

/etc/btcd/btcd.conf:
  file:
    - managed
    - template: jinja
    - source: salt://btcd/config.jinja2
    - user: root
    - group: btcd
    - mode: 440
    - context:
        listen: {{ salt["pillar.get"]("btcd:listen", ":8333") }}
        rpclisten: {{ salt["pillar.get"]("btcd:rpclisten", ":8334") }}
        rpcuser: {{ salt["pillar.get"]("btcd:rpcuser") }}
        rpcpass: {{ salt["pillar.get"]("btcd:rpcpass") }}
        debuglevel: {{ "debug" if salt["pillar.get"]("debug", False) else "info" }}
    - require:
      - file: /etc/btcd

btcd:
  user:
    - present
    - shell: /bin/false
  archive:
    - extracted
    - name: {{ btcd.install_dir }}
    - source: {{ btcd.source }}
    - source_hash: {{ btcd.source_hash }}
    - archive_format: tar
    - tar_options: j
    - if_missing: {{ btcd.install_dir }}/btcd
    - require:
      - file: {{ btcd.install_dir }}
  file:
    - managed
    - name: /etc/init/btcd.conf
    - template: jinja
    - source: salt://btcd/upstart.jinja2
    - user: root
    - group: root
    - mode: 440
    - context:
        install_dir: {{ btcd.install_dir }}
    - require:
      - archive: btcd
      - file: /etc/btcd/btcd.conf
  service:
    - running
    - watch:
      - file: btcd
      - file: /etc/btcd/btcd.conf
      - user: btcd

/etc/logrotate.d/btcd:
  file:
    - managed
    - source: salt://btcd/logrotate.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: logrotate
      - file: btcd
