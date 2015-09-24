{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set is_test = salt['pillar.get']('__test__', False) %}
cryptsetup:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/crypttab
    - require:
      - pkg: cryptsetup

{%- if is_test %}
  {%- set enc = salt["pillar.get"]("encrypt_disk", {}) %}
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
        - cmd: encrypt_disk_cleanup_{{ disk }}
      {%- for dir in bind_dirs %}
        {%- set src = mount_point ~ dir %}
encrypt_disk_bind_{{ dir }}:
  mount:
    - unmounted
    - name: {{ dir }}
    - device: /dev/mapper/{{ device_name }}
    - require_in:
      - cmd: encrypt_disk_cleanup_{{ disk }}
      {%- endfor %}
    {%- endif %}
encrypt_disk_cleanup_{{ disk }}:
  cmd:
    - run
    - name: cryptsetup luksClose '{{ device_name }}'
    - onlyif: cryptsetup luksUUID '{{ disk }}'
    - require_in:
      - pkg: cryptsetup
  file:
    - absent
    - name: '{{ disk }}'
    - require:
      - cmd: encrypt_disk_cleanup_{{ disk }}
  {%- endfor %}
{%- endif %}
