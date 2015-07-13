include:
  - apt

dns_resolver:
  pkg:
    - installed
    - name: resolvconf
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/resolvconf/resolv.conf.d/head
    - contents: |
        nameserver 127.0.0.1
        nameserver 208.67.222.222
        nameserver 8.8.8.8
    - require:
      - pkg: dns_resolver
  cmd:
    - wait
    - name: resolvconf -u
    - watch:
      - file: dns_resolver
