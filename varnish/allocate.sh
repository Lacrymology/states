#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.

# preallocate a file with given size

# safe guard
set -o nounset
set -o errexit

readonly file_path="$1"
readonly file_size="$2"
readonly file_size_value="${file_size//[a-zA-Z]/}"
readonly file_size_unit="${file_size//[0-9]/}"
readonly bs=1  # in megabytes

# count parameter to dd
count=''

if [[ "${file_size_unit}" = 'M' ]]; then
    count=$((file_size_value / bs))
elif [[ "${file_size_unit}" = 'G' ]]; then
    count=$((file_size_value * 1024 / bs))
else
    exit 1
fi

[[ -f "$file_path" ]] || ( mkdir -p $(dirname $file_path) && \
    dd if=/dev/zero of="$file_path" bs="${bs}M" count="${count}" )
