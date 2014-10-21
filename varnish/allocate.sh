#!/bin/bash

# Copyright (c) 2013, Diep Pham
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Author: Diep Pham <imeo@favadi.com>
# Maintainer: Diep Pham <imeo@favadi.com>

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
