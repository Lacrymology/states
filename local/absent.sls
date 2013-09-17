{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - diamond.absent
  - graphite.common.absent
  - graylog2.server.absent
  - graylog2.web.absent
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
