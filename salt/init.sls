{#-
 How to create a snapshot of saltstack Ubuntu PPA::

   wget -m -I /saltstack/salt/ubuntu/ \
        http://ppa.launchpad.net/saltstack/salt/ubuntu/
   mv ppa.launchpad.net/saltstack/salt/ubuntu/dists \
      ppa.launchpad.net/saltstack/salt/ubuntu/pool .
   rm -rf ppa.launchpad.net
   find . -type f -name 'index.*' -delete
   find pool/ -type f ! -name '*.deb' -delete

 to only keep lucid/precise::

   rm -rf `find dists/ -maxdepth 1 -mindepth 1 ! -name lucid ! -name precise`
   find pool/ -type f -name '*.deb' ! -name '*lucid*'  ! -name '*precise*' -delete

 -#}

salt:
  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_release'] }}.list
  apt_repository:
    - present
{%- if 'files_archive' in pillar %}
    - address: {{ pillar['files_archive'] }}/mirror/salt/{{ salt['pillar.get']('salt:version', '0.15.3') }}
{%- else %}
    - address: http://saltinwound.org/ubuntu/{{ salt['pillar.get']('salt:version', '0.15.3') }}
{%- endif %}
    - filename: saltstack-salt-{{ grains['lsb_distrib_codename'] }}
    - components:
      - main
    - key_server: keyserver.ubuntu.com
    - key_id: 0E27C0A6
    - require:
      - file: salt
  pkg:
    - installed
    - name: salt-common
    - require:
      - apt_repository: salt
