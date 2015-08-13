{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

ssl-cert:
  pkg:
    - purged
  group:
    - absent
    - require:
      - pkg: ssl-cert
  {#- don't remove /etc/ssl directory
  /etc/ssl/openssl.cnf is mandatory to use openssl #}
  file:
    - absent
    - names:
      - /etc/ssl/certs
      - /etc/ssl/private
      - /etc/ssl/dhparam.pem
    - require:
      - pkg: ssl-cert
