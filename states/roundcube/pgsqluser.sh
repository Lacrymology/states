#!/bin/bash

set -x
PASSWORD=hvnhvn
USERNAME=roundcube
su - postgres -c "createuser -R -S -d $USERNAME && createdb -O $USERNAME roundcubedb"
su - postgres -c "psql -c \"ALTER USER $USERNAME WITH PASSWORD '$PASSWORD';\""
set +x
