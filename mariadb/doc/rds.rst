Amazon RDS
==========

Automated backups
-----------------

- Backup Retention Period: 1 day
  (because of costing maybe: Amazon RDS does not charge for a backup retention
  period of one day)
- Backup Window:
  - Start Time: 10:16 UTC
  - Duration: 0.5 hour

Proposal
--------

I would suggest to do both automated backup and DB snapshot. The reason is,
there is a situation where we cannot restore from the automated backup (for
e.g. delete the instance without taking the final snapshot).

- Backup Retention Period: 8 days
- A script will take a snapshot daily and delete snapshots older than 7 days

