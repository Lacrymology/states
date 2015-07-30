dns_resolver:
  file:
    - managed
    - name: /etc/resolv.conf
    {#-
      Make sure DNS resolver config is in good shape or server may
      unable to resolve DNS after resolver formula ran.
      Two first are 2 IPs of Google DNS
      https://developers.google.com/speed/public-dns/docs/using
      followed by both IPs of OpenDNS
      https://www.opendns.com/home-internet-security/opendns-ip-addresses/
      #}
    - contents: |
        nameserver 8.8.8.8
        nameserver 8.8.4.4
        nameserver 208.67.222.222
        nameserver 208.67.220.220
