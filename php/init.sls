include:
  - apt

php:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/lucid-php5 {{ grains['lsb_distrib_codename'] }} main
    - keyid: 67E15F46
    - keyserver: keyserver.ubuntu.com
{%- else %}
    - ppa: l-mierzwa/lucid-php5
{%- endif %}
    - file: /etc/apt/sources.list.d/lucid-php5.list
    - require:
      - pkg: python-apt
      - pkg: python-software-properties
