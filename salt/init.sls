{%- set version = salt['pillar.get']('salt:version', '0.15.3') -%}
{%- set common_path = '{0}/pool/main/s/salt/salt-common_{0}-1{1}_all.deb'.format(version, grains['lsb_codename']) %}

salt-common:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - salt-common: {{ pillar['files_archive'] }}/mirror/salt/{{ common_path }}
{%- else %}
      - salt-common: http://saltinwound.org/ubuntu/{{ common_path }}
{%- endif %}
