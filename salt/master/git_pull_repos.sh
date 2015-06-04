#!/bin/bash
# Usage of this is governed by a license that can be found in doc/license.rst

set -e
file_roots="$1"
branch="$2"
function update_repo () {
  cd "$file_roots"
  cd "$1"
  git checkout --quiet "$2"
  git pull origin --quiet "$2" >/dev/null
  cd $file_roots
}

for repo in */;
do
  if [ -e "$repo/.git" ]; then
    update_repo "$repo" "$branch"
  fi
done
set +e