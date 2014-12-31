{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
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
    - order: last
