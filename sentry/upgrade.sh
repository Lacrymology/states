#!/bin/bash

set -e

upgrade_sql=$(cat <<EOF
update sentry_project set team_id =
    (select case
        when count(*) > 0 then
            (select id from sentry_team limit 1)
        else null
        end as id
    from sentry_team)
where team_id is null;
EOF
)

echo "$upgrade_sql" | psql -d sentry
