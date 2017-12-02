#!/bin/bash

repo_dir=${1:-$REPO_DIR}

source multibuild/common_utils.sh

if [ ! -f $repo_dir/LICENSE.txt ]; then
    echo "ERROR: License file in $repo_dir/ missing"
    exit 1
fi

if [ -z "$IS_OSX" ]; then
    cat LICENSE_linux.txt >> $repo_dir/LICENSE.txt
else
    cat LICENSE_osx.txt >> $repo_dir/LICENSE.txt
fi
