Troubleshoot graylog2
=====================

When troubleshooting graylog2-server, have a look at
``/var/log/upstart/graylog2-server.log``. This file exists when graylog2-server
produces log to stderr. Other graylog2-server output goes to
syslog (``/var/log/syslog``). Since graylog2 is a logging server,
for troubleshooting it, one should look into these log files as its log
messages go nowhere than these files (you would not see them on graylog2-web
user interface)
