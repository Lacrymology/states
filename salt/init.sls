salt:
  apt_repository:
    - present
{%- if 'files_archive' in pillar %}
    - address: {{ pillar['files_archive'] }}/mirror/salt/{{ salt['pillar.get']('salt:version', '0.15.3') }}
{%- else %}
    - address: http://saltinwound.org/ubuntu/{{ salt['pillar.get']('salt:version', '0.15.3') }}
{%- endif %}
    - filename: saltstack-salt-{{ grains['lsb_release'] }}
    - components:
      - main
    - key_server: keyserver.ubuntu.com
    - key_id: 0E27C0A6
