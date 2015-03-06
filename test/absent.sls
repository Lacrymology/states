include:
  - amavis.absent
  - apt_cache.absent
  - carbon.absent
  - clamav.absent
  - cron.absent
  - denyhosts.absent
  - diamond.absent
  - dovecot.absent
  - ejabberd.absent
  - elasticsearch.absent
  - etherpad.absent
  - git.absent
  - gitlab.absent
  - graylog2.server.absent
  - graylog2.web.absent
  - jenkins.absent
  - mariadb.server.absent
  - memcache.absent
  - mongodb.absent
  - nginx.absent
  - nrpe.absent
  - ntp.absent
  - openerp.absent
  - openldap.absent
  - pdnsd.absent
  - pgbouncer.absent
  - postfix.diamond.absent
  - postfix.absent
  - postgresql.server.absent
  - proftpd.absent
  - rabbitmq.absent
  - redis.absent
  - rsyslog.absent
  - salt.api.absent
  - salt.master.absent
  - shinken.arbiter.absent
  - shinken.broker.absent
  - shinken.poller.absent
  - shinken.reactionner.absent
  - shinken.receiver.absent
  - shinken.scheduler.absent
  - squid.absent
  - ssh.server.absent
  - statsd.absent
  - terracotta.absent
  - tomcat.6.absent
  - tomcat.7.absent
  - uwsgi.absent
  - varnish.absent
  - xinetd.absent

{%- set local = {
  "services": [],
  "requisites": [],
  } -%}

{%- set prefix = '/etc/init.d/' %}
{%- set init_files = salt['file.find'](prefix, name='carbon-cache-*', type='f') %}
{%- do local.services.append('carbon-relay') %}
{%- for filename in init_files %}
  {%- set instance = filename.replace(prefix + 'carbon-cache-', '') %}
  {%- do local.services.append(instance) %}
{%- endfor %}

{%- do local.services.extend([
  "amavis",
  "apt_cache",
  "clamav-daemon",
  "cron",
  "denyhosts",
  "dovecot",
  "ejabberd",
  "elasticsearch",
  "etherpad",
  "gitlab",
  "graylog2-server",
  "graylog2-web",
  "jenkins",
  "mysql-server",
  "memcached",
  "mongodb",
  "nginx",
  "ntp",
  "slapd",
  "pdnsd",
  "pgbouncer",
  "postfix_stats",
  "postfix",
  "postgresql",
  "proftpd",
  "rabbitmq-server",
  "redis",
  "salt-api",
  "salt-master",
  "shinken-arbiter",
  "shinken-broker",
  "shinken-poller",
  "shinken-reactionner",
  "shinken-receiver",
  "shinken-scheduler",
  "squid3",
  "openssh-server",
  "statsd",
  "terracotta",
  "tomcat6",
  "tomcat7",
  "uwsgi",
  "varnish",
  "xinetd",
  ]) %}
{%- set company_db = salt['pillar.get']('openerp:company_db', False) %}
{%- if company_db %}
  {%- do local.services.append(['openerp']) %}
{%- endif %}

{%- for service in local.services %}
  {#- all services except rsyslog, nsca_passsive, nrpe-nagios-server, diamond #}
  {% do local.requisites.append({"service": service}) %}
{%- endfor %}

extend:
  postgresql:
    service:
      - require:
        - service: ejabberd
        - service: etherpad
        - service: gitlab
        - service: pgbouncer
        - service: proftpd
        - service: uwsgi
{%- if company_db %}
        - service: openerp
{%- endif %}
  mongodb:
    service:
      - require:
        - service: graylog2-server
        - service: graylog2-web
  redis:
    service:
      - require:
        - service: gitlab
  nsca_passive:
    service:
      - require_in: {{ local.requisites|yaml }}
  nagios-nrpe-server:
    service:
      - require_in: {{ local.requisites|yaml }}
  diamond:
    service:
      - require_in: {{ local.requisites|yaml }}
      - require:
        - service: nsca_passive
        - service: nagios-nrpe-server
{#- append monitoring services #}
{%- do local.requisites.extend([
  {"service": "nsca_passive"},
  {"service": "nagios-nrpe-server"},
  {"service": "diamond"},
  ]) %}
  rsyslog:
    service:
      - require: {{ local.requisites|yaml }}
  salt-master:
    cmd:
      - require_in:
        - pkg: git
