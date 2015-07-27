{%- set pkgs = salt["pkg.list_pkgs"]() %}
{%- if "resolvconf" in pkgs %}
dns_resolver:
  file:
    - managed
    - name: /etc/resolvconf/resolv.conf.d/head
    {#-
      first is 2 IPs of Google DNS
      https://developers.google.com/speed/public-dns/docs/using
      followed by both IPs of OpenDNS
      https://www.opendns.com/home-internet-security/opendns-ip-addresses/
      #}
    - contents: |
        nameserver 8.8.8.8
        nameserver 8.8.4.4
        nameserver 208.67.222.222
        nameserver 208.67.220.220
  cmd:
    - wait
    - name: resolvconf -u
    - watch:
      - file: dns_resolver
{%- endif %}
