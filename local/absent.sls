include:
  - diamond.absent
  - graphite.common.absent
  - graylog2.server.absent
  - graylog2.web.absent
  - gsyslog.absent
  - pip.absent
  - raven.absent
  - requests.absent
  - route53.absent
  - salt.api.absent
  - salt.master.absent
  - sentry.absent
  - statsd.absent
  - uwsgi.absent
  - uwsgi.top.absent
  - virtualenv.absent

/usr/local:
  file:
    - absent
{% if salt['cmd.has_exec']('pip') %}
    - require:
      - pip: pip

extend:
  pip:
    pip:
      - removed
      - require:
        - pip: cherrypy
        - pip: GitPython
        - pip: raven
        - pip: requests
        - pip: route53
        - pip: uwsgitop
        - pip: virtualenv
{% endif %}
