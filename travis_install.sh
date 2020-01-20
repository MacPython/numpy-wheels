#!/bin/bash

source multibuild/common_utils.sh
source multibuild/travis_steps.sh
# Maybe get and clean and patch source
clean_code $REPO_DIR $BUILD_COMMIT
./patch_code.sh $REPO_DIR
if [ "$TRAVIS_OS_NAME"  == "linux" ]; then
    export CFLAGS=${CFLAGS}" -Wno-sign-compare -Wno-unused-result\
                             -Wno-strict-aliasing";
fi
build_wheel $REPO_DIR $PLAT
