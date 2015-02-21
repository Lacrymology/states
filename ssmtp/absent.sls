{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

ssmtp:
  pkg:
    - purged
    - pkgs:
      - bsd-mailx
      - ssmtp
  file:
    - absent
    - name: /etc/ssmtp
    - require:
      - pkg: ssmtp
