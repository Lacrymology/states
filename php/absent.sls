php:
  file:
    - absent
    - name: /etc/apt/sources.list.d/lucid-php5.list
  pkg:
    - purged
    - name: php5
  cmd:
    - run
    - name: 'apt-key del 67E15F46'
    - onlyif: apt-key list | grep -q 67E15F46
  pkgrepo:
    - absent
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/lucid-php5 {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - ppa: l-mierzwa/lucid-php5
{%- endif %}
