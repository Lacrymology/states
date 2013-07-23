php:
  pkgrepo:
    - absent
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/lucid-php5 {{ grains['lsb_codename'] }} main
    - keyid: 67E15F46
    - keyserver: keyserver.ubuntu.com
{%- else %}
    - ppa: l-mierzwa/lucid-php5
{%- endif %}
    - require:
      - pkg: python-apt
      - pkg: python-software-properties
  pkg:
    - purged
    - name: php5
