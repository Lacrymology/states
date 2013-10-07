Elasticsearch Daemon
====================

Install an Elasticsearch NoSQL server or cluster.

Elasticsearch don't support HTTP over SSL/HTTPS.
The only way to secure access to admin interface over HTTPS is to proxy
a SSL frontend in front of Elasticsearch HTTP interface.
This is why nginx is used if SSL is in pillar.
