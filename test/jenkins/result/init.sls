{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{#- run these stuff AFTER integration.py to make sure them do not be deleted/changed by integration.py #}
ci-agent:
  user:
    - present
  file:
    - name: /home/ci-agent/.ssh
    - directory
    - user: ci-agent
    - group: ci-agent
    - mode: 750
    - require:
      - user: ci-agent

/home/ci-agent/.ssh/id_rsa:
  file:
    - managed
    - name: /home/ci-agent/.ssh/id_rsa
    - user: ci-agent
    - group: ci-agent
    - mode: 400
    - contents: |
        {{ salt['pillar.get']('salt_ci:agent_privkey')|indent(8) }}
    - require:
      - file: ci-agent

/home/ci-agent/.ssh/known_hosts:
  file:
    - managed
    - user: ci-agent
    - group: ci-agent
    - mode: 644
    - contents: |
        {{ salt['pillar.get']('salt_ci:host_key')|indent(8) }}
    - require:
      - file: ci-agent

{%- set result_file = '/home/ci-agent/result.xml' -%}
{%- set test_files = salt['file.find']('/root/salt/', name='TEST-*-salt.xml') %}

openssh-client:
  pkg:
    - installed

test_result:
  file:
{%- if test_files -%}
    {#- integration.py worked #}
    - rename
    - source: {{ test_files[0] }}
{%- else -%}
    {#- integration.py failed #}
    - managed
    - source: salt://test/jenkins/result/failure.xml
{%- endif %}
    - name: {{ result_file }}
  cmd:
    - run
    - user: ci-agent
    - name: scp -P {{ salt['pillar.get']('salt_ci:ssh_port', 22) }} {{ result_file }} ci-agent@{{ grains['master'] }}:/home/ci-agent/{{ grains['id'] }}-result.xml
    - path: {{ result_file }}
    - require:
      - file: test_result
      - file: /home/ci-agent/.ssh/known_hosts
      - file: /home/ci-agent/.ssh/id_rsa
      - pkg: openssh-client

scp_logs_to_master:
  cmd:
    - run
    - name: scp -P {{ salt['pillar.get']('salt_ci:ssh_port', 22) }} /tmp/*.log.xz ci-agent@{{ grains['master'] }}:/home/ci-agent/
    - user: ci-agent
    - require:
      - file: /home/ci-agent/.ssh/known_hosts
      - file: /home/ci-agent/.ssh/id_rsa
      - pkg: openssh-client
