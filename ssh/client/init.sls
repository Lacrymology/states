{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - ssh.common

openssh-client:
  file:
    - managed
    - name: /etc/ssh/ssh_config
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://ssh/client/config.jinja2
    - require:
      - pkg: openssh-client
  pkg:
    - latest
    - require:
      - cmd: apt_sources

{%- from 'ssh/common.sls' import root_home with context %}
{%- set root_home = root_home() -%}

{#- manage multiple ssh private keys for multiple users #}
{%- set managed_keys = [] -%}
{%- set managed_locals = [] %}{# track which local users exists to make sure it's not file.directory more than once #}

{%- for domain in salt['pillar.get']('ssh:hosts', {}) %}
ssh_known_host_{{ domain }}:
  ssh_known_hosts:
    - present
    - name: {{ domain }}
  {%- set port = salt['pillar.get']('ssh:hosts:' ~ domain ~ ':port', 22) %}
  {%- if port %}
    - port: {{ port }}
  {%- endif %}
  {%- set fingerprint = salt['pillar.get']('ssh:hosts:' ~ domain ~ ':fingerprint', None) %}
  {%- if fingerprint %}
    - fingerprint: {{ fingerprint }}
  {%- endif %}
    - config: /etc/ssh/ssh_known_hosts
    - require_in:
    {#- under-hood ssh_known_hosts and pkg installing will in charge of make
        sure system wide ssh_known_hosts file exist, this is require_in
        system_ssh_known_hosts to use it as API #}
      - file: system_ssh_known_hosts
    - require:
      - pkg: openssh-client

  {%- set key_map = salt['pillar.get']('ssh:hosts:' ~ domain ~ ':keys', {}) -%}
  {%- set keyname_contents = salt['pillar.get']('ssh:keys', {}) -%}

  {%- for keyname in key_map %}
    {%- set local_remotes = key_map[keyname] if key_map[keyname] != none else {} %}
    {%- for local in local_remotes -%}
      {#- make sure /etc/ssh/keys/{{ local }} is managed only once -#}
      {%- if local not in managed_locals -%}
        {%- do managed_locals.append(local) %}
/etc/ssh/keys/{{ local }}:
  file:
    - directory
    - mode: 750
    - require:
      - file: /etc/ssh/keys
      {%- endif -%}

      {%- set remotes = local_remotes[local] %}
      {%- set remotes = [remotes] if remotes is string else remotes %}
      {%- for remote in remotes %}
        {%- set ssh_priv_key = '/etc/ssh/keys/{0}/{1}@{2}'.format(local, remote, domain) -%}
        {%- do managed_keys.append(ssh_priv_key) %}
{{ ssh_priv_key }}:
  file:
    - managed
    - makedirs: True {#- file.directory state run after this will set the expected dir mode/owner #}
    - mode: 400
    - contents: |
        {{ keyname_contents[keyname] | indent(8) }}
    - require:
      - file: /etc/ssh/keys
    - require_in:
      - file: /etc/ssh/keys/{{ local }}
      {%- endfor %}
    {%- endfor -%}
  {%- endfor -%}
{%- endfor -%}

{#- forgot_hosts formed as a dict to be consistent with its counter part - hosts #}
{%- for domain in salt['pillar.get']('ssh:forgot_hosts', {}) %}
ssh_forgot_host_{{ domain }}:
  ssh_known_hosts:
    - absent
    - name: {{ domain }}
    - require_in:
      - file: system_ssh_known_hosts
    - require:
      - pkg: openssh-client
{%- endfor %}

system_ssh_known_hosts:
  file:
    - managed
    - name: /etc/ssh/ssh_known_hosts
    - user: root
    - group: root
    - mode: 444

/etc/ssh/keys:
  file:
    - directory
    - require:
      - pkg: openssh-client

{#- remove all unmanaged keys -#}
{%- for keyfile in salt['file.find']('/etc/ssh/keys', type='f') -%}
  {%- if keyfile not in managed_keys %}
{{ keyfile }}:
  file:
    - absent
  {%- endif -%}
{%- endfor %}

{%- set root_key = salt['pillar.get']('ssh:root_key', False) -%}
{%- set extensions = ('', '.pub') -%}
{%- if root_key -%}
    {%- set type = 'rsa' if 'BEGIN RSA PRIVATE' in root_key else 'dsa' %}
root_ssh_private_key:
  file:
    - managed
    - name: {{ root_home }}/.ssh/id_{{ type }}
    - contents: |
        {{ root_key | indent(8) }}
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: {{ root_home }}/.ssh
    - require_in:
      - pkg: openssh-client
  cmd:
    - wait
    - name: ssh-keygen -y -f {{ root_home }}/.ssh/id_{{ type }} > {{ root_home }}/.ssh/id_{{ type }}.pub
    - watch:
      - file: root_ssh_private_key
    - require:
      - pkg: openssh-client

    {#- remove the other private and public key #}
    {%- for extension in extensions %}
{{ root_home }}/.ssh/id_{{ 'dsa' if type == 'rsa' else 'rsa' }}{{ extension }}:
  file:
    - absent
    - require_in:
      - file: root_ssh_private_key
    {%- endfor -%}

{%- else -%}
    {#-  remove all public and private key of root user -#}
    {%- for type in ('rsa', 'dsa') -%}
        {%- for extension in extensions %}
{{ root_home }}/.ssh/id_{{ type }}{{ extension }}:
  file:
    - absent
    - require_in:
      - pkg: openssh-client
        {%- endfor -%}
    {%- endfor -%}
{%- endif -%}
