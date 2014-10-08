{%- from 'nrpe/passive.sls' import passive_absent with context %}
{{ passive_absent('apt_cache') }}
