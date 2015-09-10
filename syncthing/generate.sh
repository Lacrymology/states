#!/bin/bash
# Usage of this is governed by a license that can be found in doc/license.rst
# Require syncthing binary in PATH
set -eu

# try GNU mktemp first, fallback to OS X mktemp if fails
tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t syncthing)
device_id=$(syncthing -generate "$tmpdir" | awk '/Device ID:/{print $5}')
pillar=$(cat <<EOF
syncthing:
  device_id: $device_id
  cert: |
$(sed -e 's/^/      /' "$tmpdir"/cert.pem)
  key: |
$(sed -e 's/^/      /' "$tmpdir"/key.pem)
EOF
)
echo "$pillar"
rm -rf "$tmpdir"
