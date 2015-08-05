{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - amavis.common
  - apt

spamassassin:
  pkg:
    - latest
    - pkgs:
      - spamassassin
      - pyzor
      - razor
    - require:
      - cmd: apt_sources

/var/lib/amavis/.pyzor:
  file:
    - directory
    - user: amavis
    - group: amavis
    - mode: 500
    - require:
      - pkg: spamassassin
      - user: amavis

{#- `pyzor discover` finds Pyzor servers from http://pyzor.sourceforge.net/cgi-bin/inform-servers-0-3-x,
and writes them to ~/.pyzor/servers.
It fails when sf.net is in the maintenance mode. #}
/var/lib/amavis/.pyzor/servers:
  file:
    - managed
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}
        public.pyzor.org:24441
    - user: amavis
    - group: amavis
    - mode: 400
    - require:
      - file: /var/lib/amavis/.pyzor

pyzor_test:
  cmd:
    - wait
    - name: pyzor ping
    - user: amavis
    - watch:
      - file: /var/lib/amavis/.pyzor/servers
