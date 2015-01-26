{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


These are required to run some Salt states/modules
for e.g, `salt.modules.dig` need `dnsutils` to be installed
-#}

salt_minion_deps:
  pkg:
    - installed
    - pkgs:
      - lsb-release
      - openssh-client {#- for ssh_known_host #}
      - unzip
      - dnsutils
      - python-psutil
      - python-openssl {#- for tls module #}
{%- if grains['virtual'] != 'openvzve' %}
      - pciutils
      - dmidecode
{%- endif %}
