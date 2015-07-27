dns_resolver:
  file:
    - managed
    - name: /etc/resolvconf/resolv.conf.d/head
    - contents: |
        nameserver 8.8.8.8
        nameserver 208.67.222.222
  cmd:
    - wait
    - name: resolvconf -u
    - watch:
      - file: dns_resolver
