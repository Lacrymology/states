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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>
-#}
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
        -----BEGIN RSA PRIVATE KEY-----
        MIIEogIBAAKCAQEAyRaXB7o9gii2Ytk8MTKIULAEMGqaednxL02tUd2FZh5ZdBpJ
        yX2X/4PZVXvCXOt0HgCbBCI/ojF8/fBCBMkCaheDUOLB2vsezi97G2gcOB3y8Tic
        zMc8UCQBAviqLcNw831ogXzB/6GHpRe2UiIBYtzZqiX5K+7fbXY5bWs+amlg/fOf
        pssiqMm2h4A5eu/9MEq0rc2SKaxujFIgEuSbF552thp41g7XSkzGE8EL7E2RcRd3
        /Y04FNZZMja3N2/CI9Fk2Gev+ylZJf0r+seKDR/aDsj5p/cZ8bQueO1t0GeByhGS
        vrgzoBhxm8+kUDMPt116TZ1CCVk/QtrhrQYjOQIDAQABAoIBAC2fb3K0YYInZIH2
        0X5D/cN4u+qUNSoSNXNLB1i8jqiFmDwMPtN1KEgzjNqlMorMbNLlxkXg01kkKzye
        Bwx44pBZd1ShrePV975F7YNhUo201cq+0mxvg5KXKJeY/VtWrUjBGjXOrWEnL9RY
        Feh6iJ/6hXPiG69JCe4W1Z6qp0WS7gFj4+7BuMAr+BuTnORYzUTLwROJ2WEf88wl
        eWpC9H487KRH1XYNB4Y1nO1vfxG4whAri5r7cHj8rZ7VIUEwMw1wcDh1Ou5tI8md
        ECj4/m9D6HqkV2wcgvyw8aIyYfky+UrcgX4QS8ariO8PV0poPM0Yi6QJGpGbmY4R
        WkcMkIUCgYEA7FBJzCpmZu1AbZsN3ZLqU/2aSe/xaK0nIBp86PIu6HCRYhXXZfiS
        OE7rgGv3PqEObNzrApFPPiseiC75xXEXFDl6XWBBdRN/2TuZsMta+iSATjFflW3v
        /ivEw7sE/Inf7DmT4et6agbs/U7LiR834+4mMuEfeWKx0MDHGEURZ98CgYEA2dcS
        dzVuTBlkIC3BdpOCTTbfWk/CJga3Ur9JoJHEgjwktFPhC1xMioqN7kLNmSPJxzHj
        bYupkyeGSjHMFdbH5bAEdlB5Oghj9Nc2HkOrLGgyDOoNVLk6cq5mlm+sa8X0Kd/v
        DwtNu7RrQA3b96AS0tqz1N5wIzNHoiFnv40Pt+cCgYAuCB239XJpDkIEl7WFub6H
        idjqGiEuQLxkVoSKY9KbWIIZVyPUKy1gZo8dPuq0em7y6b2ljGShOYkDAhOJUFQs
        jl21nrBhe+DlkeSIObSJEV8k3B1AYF/lZOU5M07vWnQR8c1KrrHzwVGcriKbnUcn
        0RYDxzJ4VK9KeKLPqXSQhQKBgApaoaMO5BYz4sFwy1BChJ/86rLVNaovCYmiU/KQ
        2yFBkJENp5WtpmmzWjmn7TPJMq8IHQI48C9xYn2mTkf/dHLjYeLpwklS2sVpcUYQ
        +1LaBP7+JPIQ98k5puChoDVjLE7NOQSjCefRFIPv5LOpZRumj4Ofqv7RUidPpSnC
        n6ujAoGAM0OHFyB0gL1yYbnKqPuXUat7nszguSa9cSTNi2EgGOutLSZ/AM26Q0VG
        LKLFD8y4iHDDipl+gl95kiAfT4fYuvmlrP6FqYsWIUhmiXeZ1Q72gWVACpWahePS
        /t4JiM9NEutEiTpZkPvuF6rWlyszaf9Rt5YK7kdl9WZXO1IHvCc=
        -----END RSA PRIVATE KEY-----
    - require:
      - file: ci-agent

/home/ci-agent/.ssh/known_hosts:
  file:
    - managed
    - user: ci-agent
    - group: ci-agent
    - mode: 644
    - contents: |
        192.241.129.134 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCw9cc4ZJLleh8XqzowTKh/BkJcZdvnEcEqXf0NUa4abi+YuRCvwnpQTSG+dV1YQ+bk6fpAVM2Za7ypOdxeelclqgrV8vvs3IKtkRe+XMAkHv2IYYEvHa3lwpa6A+n+y3jt/Y0B8a04laMJqxzUMSWnsJ//uDTj8TEwkAWw0KbpMIJnQqRAsMjopV9Rh8VAxvbKMweq7I+uD7Fc2I8z1yFpiJuQqP6ul4E38ZoRJRXdM2btmrWSkGGkiww8uGYN/LgUVy/D6gcapzQjREc73P7mRbwAzdjeC/sLcIEZf9D9SZ8jNsIwogZ0AthBwBWMpbh7gj2t0MIX4VIREeJ1KWsV
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
    - name: scp {{ result_file }} ci-agent@{{ grains['master'] }}:/home/ci-agent/{{ grains['id'] }}-result.xml
    - path: {{ result_file }}
    - require:
      - file: test_result
      - file: /home/ci-agent/.ssh/known_hosts
      - file: /home/ci-agent/.ssh/id_rsa
      - pkg: openssh-client

{%- for type in ('stdout', 'stderr') %}
{{ type }}:
  cmd:
    - run
    - name: xz -c /root/salt/{{ type }}.log > /home/ci-agent/{{ type }}.log.xz

scp_{{ type }}_to_master:
  cmd:
    - run
    - name: scp /home/ci-agent/{{ type }}.log.xz ci-agent@{{ grains['master'] }}:/home/ci-agent/{{ grains['id'] }}-{{ type }}.log.xz
    - user: ci-agent
    - require:
      - cmd: {{ type }}
      - file: /home/ci-agent/.ssh/known_hosts
      - file: /home/ci-agent/.ssh/id_rsa
      - pkg: openssh-client
{%- endfor %}
