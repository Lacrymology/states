{#-
Copyright (c) 2013, <HUNG NGUYEN VIET>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Hung Nguyen Viet hvnsweeting@gmail.com
Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
NFS: Network File System
=============================

Mandatory Pillar
----------------

nfs:
  allow: 192.168.122.1, 192.168.122.8

nfs:allow: list of allow hosts

Optional Pillar
---------------

nfs:
  deny: ALL
  procs: 8
  exports:
    /srv/salt:
      192.168.122.0/24: rw,sync,no_subtree_check,no_root_squash
      192.168.32.21: ro
    /tmp:
      192.168.122.1: rw,sync,no_subtree_check,no_root_squash

nfs:deny: list of deny hosts. Default: ALL
nfs:exports: files to share and hosts that can access to it with specified options
nfs:procs: numbers of nfs processes. Default: 8
-#}

include:
  - apt

/etc/exports:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/server/exports.jinja2
    - require:
      - pkg: nfs-kernel-server

/etc/default/nfs-kernel-server:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/server/default.jinja2
    - require:
      - pkg: nfs-kernel-server

nfs-kernel-server:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: nfs-kernel-server
      - file: /etc/default/nfs-kernel-server
      - file: /etc/exports

{%- set allow = salt['pillar.get']('nfs:allow') -%}
{%- set deny = salt['pillar.get']('nfs:deny', 'ALL') -%}
{%- set type2clients = {'allow': allow,
                        'deny': deny} %}

{%- for t in type2clients %}
  {%- for service in 'portmap', 'lockd', 'rquotad', 'mountd', 'statd' %}
nfs_{{ service }}_{{ t }}:
  tcp_wrappers:
    - present
    - type: {{ t }}
    - name: {{ type2clients[t] }}
    - service: {{ service }}
    - require:
      - pkg: nfs-kernel-server
  {%- endfor %}
{%- endfor %}
