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
{% for nameserver in salt['pillar.get']('resolver:nameservers', []) %}
        nameserver {{ nameserver }}
{% endfor %}
    - require:
      - pkg: dns_resolver
  cmd:
    - wait
    - name: resolvconf -u
    - watch:
      - file: dns_resolver
