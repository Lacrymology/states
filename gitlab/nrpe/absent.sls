{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Remove GitLab NRPE checks.
-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('gitlab') }}

/etc/nagios/nrpe.d/gitlab-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-gitlab.cfg:
  file:
    - absent
