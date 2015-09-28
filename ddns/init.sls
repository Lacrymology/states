{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{# -*- ci-automatic-discovery: off -*-
This formula needs a working DNS authoritative server to work, it
will be tested with bind in test.sls
#}

include:
  - pip

ddns_dnspython:
  pip:
    - installed
    - name: dnspython
    - reload_modules: True
    - require:
      - module: pip

ddns_tsig_key:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/ddns
    - template: jinja
    - source: salt://ddns/tsig.jinja2
    - user: root
    - group: root
    - mode: 400

ddns_setup_dynamic_dns:
  ddns:
    - present
    - name: {{ grains['id'] }}
    - zone: {{ salt['pillar.get']('ddns:zone') }}
    - ttl: {{ salt['pillar.get']('ddns:ttl', 3600) }}
    - nameserver: {{ salt['pillar.get']('ddns:nameserver') }}
    - data: {{ salt['pillar.get']('ddns:public_ip', salt['network.interface_ip']('eth0')) }}
    - keyfile: {{ opts['cachedir'] }}/ddns
    - watch:
      - file: ddns_tsig_key
    - require:
      - pip: ddns_dnspython
