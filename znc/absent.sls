{%- set version = "1.4-1" %}

znc:
  pkg:
    - purged
  cmd:
    - run
    - name: 'apt-key del E616D378'
    - onlyif: apt-key list | grep -q E616D378
  pkgrepo17:
    - absent
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/znc/{{ version }} {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - ppa: teward/znc
{%- endif %}

/etc/apt/sources.list.d/znc.list:
  file:
    - absent
    - require:
      - pkgrepo17: znc
