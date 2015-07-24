#!/bin/bash
# Usage of this is governed by a license that can be found in doc/license.rst

set -e

source /usr/local/share/salt_common.sh
locking_script
log_start_script "$@"
trap "log_stop_script \$?" EXIT

file_roots="$1"
branch="$2"

function update_repo () {
  repo_path="$1"
  cd "$file_roots"
  cd "$repo_path"
  git checkout --quiet "$branch"
  git fetch --quiet origin "$branch"
  git reset --hard --quiet FETCH_HEAD
  cd "$file_roots"
}

cd "$file_roots"
for repo in */; do
  if [ -e "$repo/.git" ]; then
    update_repo "$repo" "$branch"
  fi
done
set +e
