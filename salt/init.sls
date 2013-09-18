{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
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
{%- if grains['saltversion'] == '0.15.3' %}
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_release'] }}.list
{%- else %}
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_release'] }}.list
{%- endif %}
  apt_repository:
    - present
{%- if 'files_archive' in pillar %}
    - address: http://archive.robotinfra.com/mirror/salt/{{ salt['pillar.get']('salt:version', '0.16.4') }}
{#    - address: {{ pillar['files_archive'] }}/mirror/salt/{{ salt['pillar.get']('salt:version', '0.16.4') }}#}
{%- else %}
    - address: http://archive.robotinfra.com/mirror/salt/{{ salt['pillar.get']('salt:version', '0.16.4') }}
{%- endif %}
{%- if grains['saltversion'] == '0.15.3' %}
    - filename: saltstack-salt-{{ grains['lsb_codename'] }}
{%- else %}
    - filename: saltstack-salt-{{ grains['lsb_distrib_codename'] }}
{%- endif %}
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
