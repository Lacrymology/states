{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

cryptsetup:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/crypttab
    - require:
      - pkg: cryptsetup

{%- set enc = salt["pillar.get"]("encrypt_disk", {}) %}
{%- set is_test = salt['pillar.get']('__test__', False) %}
{%- for disk, config in enc.iteritems() %}
  {%- set device_name = disk|replace("/", "_") %}
  {%- set mount_point = salt["pillar.get"]("encrypt_disk:" ~ disk ~ ":block", False) %}
  {%- set bind_dirs = salt["pillar.get"]("encrypt_disk:" ~ disk ~ ":bind", []) %}
  {%- if mount_point %}
unmount_disk_{{ disk }}:
  mount:
    - unmounted
    - name: {{ mount_point }}
    - device: /dev/mapper/{{ device_name }}
    - require_in:
        - cmd: cleanup_{{ disk }}
    {%- for dir in bind_dirs %}
      {%- set src = mount_point ~ dir %}
bind_{{ dir }}:
  mount:
    - unmounted
    - name: {{ dir }}
    - device: /dev/mapper/{{ device_name }}
    - require_in:
      - cmd: cleanup_{{ disk }}
    {%- endfor %}
  {%- endif %}
  {%- if is_test %}
cleanup_{{ disk }}:
  cmd:
    - run
    - name: cryptsetup luksClose '{{ device_name }}'
    - onlyif: which cryptsetup && cryptsetup luksUUID '{{ disk }}'
    - require_in:
      - pkg: cryptsetup
  file:
    - absent
    - name: '{{ disk }}'
    - require:
      - cmd: cleanup_{{ disk }}
  {%- endif %}
{%- endfor %}
