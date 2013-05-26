#!/bin/bash

PASSWORD=hvnhvn
USERNAME=roundcube
DBNAME=roundcubedb
su - postgres -c "createuser -R -S -d $USERNAME; createdb -O $USERNAME $DBNAME"
su - postgres -c "psql -c \"ALTER USER $USERNAME WITH PASSWORD '$PASSWORD';\""
su - postgres -c "echo '127.0.0.1:*:*:'$USERNAME:$PASSWORD > ~/.pgpass; chmod 600 ~/.pgpass"
su - postgres -c "psql -d roundcubedb -U roundcube -f  {{ dir }}/SQL/postgres.initial.sql -h 127.0.0.1 -w"
