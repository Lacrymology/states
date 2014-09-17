include:
  - apt

{%- set version = "1.4-1" %}

znc:
  pkgrepo17:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/znc/{{ version }} {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://znc/key.gpg
{%- else %}
    - ppa: teward/znc
{%- endif %}
    - file: /etc/apt/sources.list.d/znc.list
    - require:
      - pkg: apt_sources
  pkg:
{%- if 'files_archive' in pillar %}
    - installed
{%- else %}
    - latest
{%- endif %}
    - require:
      - cmd: apt_sources
