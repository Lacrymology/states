{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

ssl-cert:
  pkg:
    - purged
  group:
    - absent
    - require:
      - pkg: ssl-cert

{#-
don't remove /etc/ssl directory
/etc/ssl/openssl.cnf is mandatory to use openssl
#}
/etc/ssl/certs:
  file:
    - absent
    - require:
      - pkg: ssl-cert

/etc/ssl/private:
  file:
    - absent
    - require:
      - pkg: ssl-cert
