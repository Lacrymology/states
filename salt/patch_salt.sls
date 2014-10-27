{%- from "macros.jinja2" import salt_version with context %}
{%- set version = salt_version() %}

patch_salt_fix_require_sls:
  file:
    - name: /usr/share/pyshared/salt/state.py
{%- if salt['pkg.version']('salt-common') == '2014.1.10-1precise1' %}
    - patch
    - hash: md5=d6ef399200223833bc4e156588eeedca
    - source: salt://salt/require_sls.patch
{%- else %}
    - exists
{%- endif %}
