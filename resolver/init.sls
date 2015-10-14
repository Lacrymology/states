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
      - file: dns_resolver_config_append

dns_resolver_config_append:
  file:
    - managed
    - name: /etc/resolvconf/resolv.conf.d/tail
    - contents: |
{% for nameserver in salt['pillar.get']('resolver:append', []) %}
        nameserver {{ nameserver }}
{% endfor %}
    - require:
      - pkg: dns_resolver
